import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;
  final CollectionReference userFriendsData = FirebaseFirestore.instance.collection('userFriendsData');
  final CollectionReference userEmail = FirebaseFirestore.instance.collection('userEmail');

  //  data is of the form amount: int, desc string?, paid_by: string
  Future addActivity(
      String paidBy, int amount, String? desc, String gid) async {
    db.collection('groups').doc(gid).collection('activity').add({
      'amount': amount,
      'desc': desc,
      'paid_by': paidBy,
    });
    db
        .collection('groups')
        .doc(gid)
        .collection('members')
        .doc(paidBy)
        .update({'contribution': FieldValue.increment(amount)});
  }

  Future CreateGroup(List<String> memberid) async {
    final newgroupRef = db.collection('groups').doc();
    for (var element in memberid) {
      db.collection('users').doc(element).get().then((DocumentSnapshot value) {
        final data = value.data() as Map<String, dynamic>;
        newgroupRef.collection('members').doc(element).set({
          'user_name': data['name'],
          'contribution': 0,
        });
      });
    }
    for (var element in memberid) {
      db
          .collection('user_grp')
          .doc(element)
          .set({newgroupRef.id: true}, SetOptions(merge: true));
    }
  }

  Future CreateUser(
      String uid, String email, String name) async {
    db.collection('users').doc(uid).set({
      'email': email,
      'name': name,
    });
    db.collection('userEmail').doc(email).set({'uid' : uid});
  }


  Future addFriend(String email) async {
    int flag = 0;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
    return await db.collection('userEmail').doc(email).get().then((snapshot) {
        if(snapshot.data()?.length != 0) {
          final data = snapshot.data();
          final friendId = data?['uid'];
          if(friendId != null && friendId != userId){
            userFriendsData.doc(userId).update({
              '$friendId': 0,
            });
            userFriendsData.doc(friendId).update({
              '$userId': 0,
            });
          }else{
            if(friendId == userId){
              return Future.error('same email');
            }
            else if(friendId == null){
              return Future.error('invalid');
            }
          }
        }
    });
  }
  Stream<DocumentSnapshot> get friends {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return userFriendsData.doc(userId).snapshots();
   }

  Future<Map<dynamic, dynamic>> getGroupsOfAUser(String uid) async {
    final groups = await db.collection('user_grp').doc(uid).get();
    final data = groups.data() as Map<dynamic, dynamic>;
    return data;
  }
}
