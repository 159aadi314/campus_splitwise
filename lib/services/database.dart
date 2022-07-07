import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;
  final CollectionReference userFriendsData =
      FirebaseFirestore.instance.collection('userFriendsData');
  final CollectionReference userEmail =
      FirebaseFirestore.instance.collection('userEmail');
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

  Future CreateGroup(Map<String, dynamic> memberid, String grpName) async {
    final newgroupRef = db.collection('groups').doc();
    Map<String, dynamic> temp1 = {};
    Map<String, dynamic> members = {};
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final q = await db.collection('users').doc(userId).get();
    String userName = q.data()?['name'];
    temp1['name'] = userName;
    temp1['contribution'] = 0;
    members[userId] = temp1;
    db
        .collection('user_grp')
        .doc(userId)
        .set({newgroupRef.id: true}, SetOptions(merge: true));
    memberid.forEach((key, value) {
      temp1['name'] = value;
      temp1['contribution'] = 0;
      members[key] = temp1;
      db
          .collection('user_grp')
          .doc(key)
          .set({newgroupRef.id: true}, SetOptions(merge: true));
    });
    newgroupRef.set({
      'members': members,
      'name': grpName,
    });
  }

  Future CreateUser(String uid, String email, String name) async {
    db.collection('users').doc(uid).set({
      'email': email,
      'name': name,
    });
<<<<<<< HEAD
    db.collection('userEmail').doc(email).set({'uid': uid});
=======
    FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    db.collection('userEmail').doc(email).set({'uid' : uid});
>>>>>>> 9916f03e63169cab31f53debb8cced8dca902a2a
    db.collection('userFriendsData').doc(uid).set({});
    db.collection('user_grp').doc(uid).set({});
  }

  Future addFriend(String email) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return await db
        .collection('userEmail')
        .doc(email)
        .get()
        .then((snapshot) async {
      if (snapshot.data()?.length != 0) {
        final data = snapshot.data();
        final friendId = data?['uid'];
        if (friendId != null && friendId != userId) {
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
          userFriendsData.doc(userId).update({
            '$friendId': [0, friendName]
          });
          userFriendsData.doc(friendId).update({
            '$userId': [0, userName],
          });
        } else {
          if (friendId == userId) {
            return Future.error('same email');
          } else if (friendId == null) {
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
      ans.add({'id': key, 'IOU': value[0], 'name': value[1]});
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

  Future<void> addExpense(String uid, String friendId, String friendName,
      int friendIOU, String description, int amount) async {
    final p = await db.collection('users').doc(uid).get();
    String userName = p.data()?['name'];
    await db.collection('userFriendsData').doc(uid).update({
      friendId: [friendIOU - amount, friendName]
    });
    await db.collection('userFriendsData').doc(friendId).update({
      uid: [-friendIOU + amount, userName]
    });
  }
}
