import 'package:flutter/material.dart';
import 'package:adding_expense_2/src/friends.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Splitwise',
      theme: ThemeData(
          brightness: Brightness.dark
      ),
      home: FriendsPage(),
    );
  }
}

