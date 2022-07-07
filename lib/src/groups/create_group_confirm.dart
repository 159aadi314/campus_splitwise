import 'package:campus_splitwise/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key, required this.groupUsers}) : super(key: key);
  final Map<String, dynamic> groupUsers;
  @override
  _CreateGroup createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  String grpName = '';
  final _formKey = GlobalKey<FormState>();
  final DatabaseService db = DatabaseService();
  String people = "Members: ";
  @override
  void initState() {
    super.initState();
    widget.groupUsers.forEach((key, value) {
      people = people + value;
      people = "$people, ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Group Name"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            // shift 10 unit left
            padding: EdgeInsets.only(right: 10),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                db.CreateGroup(widget.groupUsers, grpName);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(children: <Widget>[
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.group_add,
                    size: 24.0,
                    semanticLabel: 'Description icon',
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Add Group Name ...',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        grpName = val;
                      });
                    },
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
          child: Text(
            people.substring(0, people.length - 2),
            style: TextStyle(fontSize: 18),
          ),
        ),
      ]),
    );
  }
}
