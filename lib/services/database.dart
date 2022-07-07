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
    FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    db.collection('userEmail').doc(email).set({'uid' : uid});
    db.collection('userFriendsData').doc(uid).set({});
  }


  Future addFriend(String email) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return await db.collection('userEmail').doc(email).get().then((snapshot) async {
        if(snapshot.data()?.length != 0) {
          final data = snapshot.data();
          final friendId = data?['uid'];
          if(friendId != null && friendId != userId){

            // DocumentReference d = userFriendsData.doc(userId);
            // d.get().then((snapshot){
            //   if(snapshot.exists){
            //     d.update('$friendId')
            //   }else{
            //     d.set({'$friendId' : 0});
            //   }
            // });
            final p = await db.collection('users').doc(friendId).get();
            String friendName = p.data()?['name'];
            final q = await db.collection('users').doc(userId).get();
            String userName = q.data()?['name'];
            userFriendsData.doc(userId).update({'$friendId' : [0, friendName]});
            userFriendsData.doc(friendId).update({
              '$userId': [0, userName],
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
  Future<List<Map<String, dynamic>>> getFriendsOfAUser(String uid) async {
    List<Map<String, dynamic>> ans = [];
    final friends = await db.collection('userFriendsData').doc(uid).get();
    final data = friends.data() as Map<String, dynamic>;
    data.forEach((key, value) async {
      ans.add({'id' : key, 'IOU' : value[0], 'name' : value[1]});
    });
    return ans;
  }

   Future<Map<String, dynamic>> getUsername(String? uid) async {
    final user = await db.collection('users').doc(uid).get();
    return await {'name':user.data()?['name']};
  }
  Future<Map<dynamic, dynamic>> getGroupsOfAUser(String uid) async {
    final groups = await db.collection('user_grp').doc(uid).get();
    final data = groups.data() as Map<dynamic, dynamic>;
    return data;
  }

  Future<void> addExpense(String uid, String friendId, String friendName, int friendIOU, String description, int amount) async{
    final p = await db.collection('users').doc(uid).get();
    String userName = p.data()?['name'];
    await db.collection('userFriendsData').doc(uid).update({friendId : [friendIOU-amount, friendName]});
    await db.collection('userFriendsData').doc(friendId).update({uid : [-friendIOU+amount, userName]});
  }
}