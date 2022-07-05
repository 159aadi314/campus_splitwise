import 'package:flutter/material.dart';
import 'package:split_temp/services/auth.dart';

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text(
          'Welcome User',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: Text('logout'),
          )
        ],
      ),
    );
  }
}
