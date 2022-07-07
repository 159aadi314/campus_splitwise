import 'package:firebase_auth/firebase_auth.dart';

class myUser {
  final String uid;
  final String? email;
  final String? name;
  myUser({required this.uid, required this.email, required this.name});
}