import 'package:campus_splitwise/services/database.dart';
import 'package:flutter/material.dart';
import 'package:campus_splitwise/services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  static const id = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  String email = '';
  String password = '';
  String error = '';
  String name = '';

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up to split-wise'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Enter an non null email";
                      } else {
                        return val.isEmpty ? "Enter an email" : null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Enter an non null Name";
                      } else {
                        return val.isEmpty ? "Enter a Name" : null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (val) {
                      if (val == null) {
                        return "Enter a non null password of minimum 6 chars";
                      } else {
                        return val.length < 6
                            ? "Enter a password of minimum 6 chars"
                            : null;
                      }
                    },
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Enter a valid email';
                            });
                          } else {
                            Navigator.pop(context);
                            print(result.uid);
                            await _db.CreateUser(
                                result.uid, email, name);
                            setState(() {
                              error = '';
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.black),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  )
                ],
              ))),
    );
  }
}
