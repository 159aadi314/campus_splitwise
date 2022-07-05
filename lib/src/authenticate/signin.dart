import 'package:flutter/material.dart';
import 'package:campus_splitwise/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static const id = "/sign_in";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to split-wise'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
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
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
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
                        'Sign In',
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