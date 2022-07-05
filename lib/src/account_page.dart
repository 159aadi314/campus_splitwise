import 'package:flutter/material.dart';
import 'package:campus_splitwise/services/auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text('logout'),
            )
          ],
        ),
      ),
    );
  }
}
