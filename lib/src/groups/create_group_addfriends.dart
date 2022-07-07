import 'package:campus_splitwise/services/database.dart';
import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/groups/create_group_confirm.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseService().getFriendsOfAUser(FirebaseAuth.instance.currentUser?.uid ?? ''),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return BuildPage(allfriends: snapshot.data ?? []);
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}


class BuildPage extends StatefulWidget {
  const BuildPage({Key? key, required this.allfriends}) : super(key: key);

  final List<Map<String, dynamic>> allfriends;

  @override
  _AddGroupPage createState() => _AddGroupPage();
}

class _AddGroupPage extends State<BuildPage> {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Map<String, dynamic>> _allfriends = [];
  Map<String, dynamic> val = {};
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _foundUsers = [];
  Map<String, dynamic> group_users = {};
  @override
  initState() {
    _allfriends.addAll(widget.allfriends);
    _allfriends.forEach((element) {
      val[element['id']] = false;
    });
    _foundUsers = _allfriends;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allfriends;
    } else {
      results = _allfriends
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  bool value = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'createGroup',
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Members to the group"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 35, 34, 34),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                        labelText: 'Search friends',
                        suffixIcon: Icon(Icons.search)),
                    validator: (value) {
                      if (group_users.isEmpty)
                        return "Please add at least 1 user";
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundUsers.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) =>
                            buildBox(_foundUsers[index]),
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGroup(groupUsers: group_users)),
              );
            }
          },
          // Add your onPressed code here!

          child: const Icon(Icons.keyboard_arrow_right_rounded, size: 40),
        ),
      ),
    );
  }

  Widget buildBox(Map<String, dynamic> friend) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
        child: Card(
          key: ValueKey(friend['id']),
          elevation: 2,
          color: val[friend['id']] ? Color.fromARGB(255, 49, 102, 196) : null,
          child: ListTile(
            visualDensity: VisualDensity.comfortable,
            // increase size of this icon
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: const Icon(Icons.person),
            title: Text(friend['name'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            onTap: () {
              print(friend);
              print(val);
              setState(() => val[friend['id']] = !val[friend['id']]);
              print(friend);
              print(val);
              if (val[friend['id']])
                group_users[friend['id']] = friend['name'];
              else
                group_users.remove(friend['id']);
              print(group_users);
            },
          ),
        ),
      );
}
