import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:campus_splitwise/models/user.dart';
import 'package:campus_splitwise/src/authenticate/register.dart';
import 'package:campus_splitwise/src/authenticate/signin.dart';
import 'package:campus_splitwise/src/wrapper.dart';
import 'package:campus_splitwise/services/auth.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
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
        title: 'Campus Splitwise',
        theme: ThemeData(brightness: Brightness.dark),
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
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
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
