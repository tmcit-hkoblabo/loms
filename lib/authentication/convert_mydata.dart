/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NextPage extends StatefulWidget {
  FirebaseUser userData;

  NextPage({Key key, this.userData}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState(userData);
}

class _NextPageState extends State<NextPage> {
  FirebaseUser userData;
  String name = "";
  String email;
  String photoUrl;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  _NextPageState(FirebaseUser userData) {
    this.userData = userData;
    this.name = userData.displayName;
    this.email = userData.email;
    this.photoUrl = userData.photoUrl;
  }

  Future<void> _handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }
}*/
