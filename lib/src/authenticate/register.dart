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
  String email = '';
  String password = '';
  String error = '';

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
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
                            setState(() {
                              error = '';
                            });
                          }
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
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