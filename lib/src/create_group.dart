import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();

  // initial values of the friend as empty map
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'create-group',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a new group'),
        ),
        body: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Group name',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all( 40),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check, color: Colors.black),
                  // shift 10 unit left
                  label: Text('Confirm', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                    if (_formKey.currentState!.validate()) {
                      // _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ]
        ),
      ),
    );
  }
}