import 'package:campus_splitwise/services/database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  String email = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  // initial values of the friend as empty map
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'add-friend',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add a friend'),
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
                      const Expanded(
                        flex: 1,
                        child:  Icon(
                          Icons.email_rounded,
                          size: 24.0,
                          semanticLabel:
                              'Description icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'enter email ...',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          autofocus: true,
                          validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
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
                primary: Color.fromARGB(255, 93, 255, 228),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                     _db.addFriend(email).then((v) {
                       setState(() {
                       error = '';
                      });
                      Navigator.pop(context);
                     }).catchError((e){
                       if(e == 'invalid') {
                         setState(() {
                           error = 'User with this email does not exist';
                         });
                       }
                       else if(e == 'same email'){
                         setState(() {
                           error = "You can't add yourself as friend!";
                         });
                       }
                       print(error);
                     });

                  }
                  //_formKey.currentState!.save();
                }
            ),
            ),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 15),
          )
          ] 
        ),
      ),
    );
  }
}
