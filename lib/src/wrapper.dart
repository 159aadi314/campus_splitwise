import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_splitwise/models/user.dart';
import 'package:campus_splitwise/src/authenticate/authenticate.dart';
import 'package:campus_splitwise/src/MainPage.dart';

class Wrapper extends StatelessWidget {
  // const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    // return home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return MainPage(uid: user.uid);
    }
  }
}
