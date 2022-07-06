import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key, required this.groupUsers}) : super(key: key);
  final Map<String,dynamic> groupUsers;
  @override
  _CreateGroup createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  final _formKey= GlobalKey<FormState>();
  String people="Members: ";
  @override
  void initState() {
    super.initState();
    widget.groupUsers.forEach((key, value) {people=people+value; people= "$people, ";});
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
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }

            },

          ),
        ],
      ),
      body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child:  Icon(
                        Icons.group_add,
                        size: 24.0,
                        semanticLabel:
                        'Description icon',
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
                        autofocus: true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
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
              child: Text(people.substring(0, people.length-2), style: TextStyle(fontSize: 18),),
            ),
          ]
      ),

    );
  }

} 