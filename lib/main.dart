import 'package:campus_splitwise/src/account_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/friends.dart';
import 'package:campus_splitwise/src/activity_page.dart';
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
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  final String title = 's';
  final screens = [
    ActivityPage(),
    FriendsPage(),
    AccountPage(),
  ];
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _title = 'Recent Activity';
  final List<Widget> _screens = [
    ActivityPage(),
    FriendsPage(),
    AccountPage(),
  ];
  // @override
  // initState(){
  //   _title = 'Some default value';
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(_title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 35, 34, 34),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
        onTap: (int index) {
          setState(() {
          _currentIndex = index;
            switch(index) {
              case 0: { _title = 'Recent Activity'; }
              break;
              case 1: { _title = 'Your Friends'; }
              break;
              case 2: { _title = 'Your Profile'; }
              break;
            }
          }
          );
        },
      ),
    );
  }
}

