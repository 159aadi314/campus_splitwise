import 'package:campus_splitwise/src/groups/compute_mapping.dart';
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
    members[userId] = {
      'name': userName,
      'contribution': 0,
    };
    db
        .collection('user_grp')
        .doc(userId)
        .set({newgroupRef.id: grpName}, SetOptions(merge: true));
    memberid.forEach((key, value) {
      members[key] = {
        'name': value,
        'contribution': 0,
      };
      db
          .collection('user_grp')
          .doc(key)
          .set({newgroupRef.id: grpName}, SetOptions(merge: true));
    });
    newgroupRef.set({
      'members': members,
      'name': grpName,
    });
    final newgrpTRef =
        db.collection('grp_t').doc(newgroupRef.id).set({'t': {}});
  }

  Future CreateUser(String uid, String email, String name) async {
    db.collection('users').doc(uid).set({
      'email': email,
      'name': name,
    });
    FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    db.collection('userEmail').doc(email).set({'uid': uid});
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
    return await {'name': user.data()?['name']};
  }

  Future<List<Map<String, dynamic>>> getGroupsOfAUser(String uid) async {
    List<Map<String, dynamic>> ans = [];
    final groups = await db.collection('user_grp').doc(uid).get();
    final data = groups.data() as Map<dynamic, dynamic>;
    data.forEach((key, value) async {
      ans.add({'id': key, 'name': value.toString()});
    });
    return ans;
  }

  Future<List<Map<String, dynamic>>> getUsersOfAGroup(String gid) async {
    List<Map<String, dynamic>> ans = [];
    final groups = await db.collection('groups').doc(gid).get();
    final data = groups.data() as Map<dynamic, dynamic>;
    data['members']?.forEach((key, value) async {
      ans.add({
        'uid': key,
        'name': value['name'].toString(),
        'contribution': value['contribution']
      });
    });
    return ans;
  }

  Future<Map<String, dynamic>> getTsOfAGroup(String gid, String uid) async {
    List<Map<String, dynamic>> ans = [];
    final groups = await db.collection('grp_t').doc(gid).get();
    final myNameRef = await getUsername(uid);
    final myName = myNameRef['name'] as String;
    final data = groups.data() as Map<dynamic, dynamic>;
    bool getBack = false;
    data['t']?.forEach((key, value) async {
      if (value['getter'] == myName) {
        getBack = true;
        ans.add({
          'friend_name': value['giver'],
          'amount': value['amount'],
        });
      } else if (value['giver'] == myName) {
        ans.add({
          'friend_name': value['getter'],
          'amount': value['amount'],
        });
      }
    });
    final Map<String, dynamic> mapping = {
      'connected_users': ans,
      "get_back": getBack,
    };
    return mapping;
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

  Future<void> addContribution(
      String uid, Map<dynamic, dynamic> group, int amount) async {
    // update members list with contribution, then use the members list to add amount to the mapping
    await db.collection('groups').doc(group['id']).update({
      "members.$uid.contribution": FieldValue.increment(amount),
    });
    final groups = await db.collection('groups').doc(group['id']).get();
    final data = groups.data() as Map<dynamic, dynamic>;
    final members = data['members'] as Map<dynamic, dynamic>;
    final ts = computeMapping(members);
    // first delete existing value of the mapping, then add the new value
    await db.collection('grp_t').doc(group['id']).update({
      't': FieldValue.delete(),
    });
    ts.forEach((key, value) {
      db.collection('grp_t').doc(group['id']).update({
        't.$key': value,
      });
    });
  }
}
