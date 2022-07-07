import 'package:campus_splitwise/src/account_page.dart';
import 'package:campus_splitwise/src/groups/groups_home_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/friends/friends.dart';
import 'package:campus_splitwise/src/activity_page.dart';

class MainPage extends StatefulWidget {
  final String uid;
  MainPage({required this.uid});
  final String title = 's';
  final screens = [
    const GroupsPage(),
    const ActivityPage(),
    const FriendsPage(),
    const AccountPage(),
  ];
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _title = 'Your Groups';
  final List<Widget> _screens = [
    const GroupsPage(),
    const ActivityPage(),
    const FriendsPage(),
    const AccountPage(),
  ];
  // @override
  // initState(){
  //   _title = 'Some default value';
  // }
  @override
  Widget build(BuildContext context) {
    const bgcolor = Color.fromARGB(255, 93, 255, 228);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 35, 34, 34),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: bgcolor),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: bgcolor),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: bgcolor),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded, color: bgcolor),
            label: 'Account',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                {
                  _title = 'Your Groups';
                }
                break;
              case 1:
                {
                  _title = 'Recent Activity';
                }
                break;
              case 2:
                {
                  _title = 'Your Friends';
                }
                break;
              case 3:
                {
                  _title = 'Your Profile';
                }
                break;
            }
          });
        },
      ),
    );
  }
}
