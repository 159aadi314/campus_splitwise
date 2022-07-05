import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_temp/models/user.dart';
import 'package:split_temp/screens/authenticate/register.dart';
import 'package:split_temp/screens/authenticate/signin.dart';
import 'package:split_temp/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:split_temp/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<myUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
        onGenerateRoute: RouteMaker.generateRoute,
      ),
    );
  }
}

class RouteMaker {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Register.id:
        return MaterialPageRoute(builder: (context) => Register());
      case SignIn.id:
        return MaterialPageRoute(builder: (context) => SignIn());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
