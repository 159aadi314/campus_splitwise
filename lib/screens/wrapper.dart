import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_temp/models/user.dart';
import 'package:split_temp/screens/authenticate/authenticate.dart';
import 'package:split_temp/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  // const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    // return home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
