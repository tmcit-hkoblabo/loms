import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final furiganaController = TextEditingController();
  final positionController = TextEditingController();

  String? name;
  String? email;
  String? uid;
  String? image;
  String? furigana;
  String? position;
  String? password;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //使っていない
  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  //使っていない
  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setFurigana(String furigana) {
    this.furigana = furigana;
    notifyListeners();
  }

  void setPosition(String position) {
    this.position = position;
    notifyListeners();
  }

  //今の所使っていない
  Future login() async {
    this.email = titleController.text;
    this.password = authorController.text;

    if (email != null && password != null) {
      // ログイン
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
    }
  }

  //GoogleSignInとfirestoreへの登録を同時に行える関数
  //ただあまり使いこなせなかったので一旦不使用
  Future signinOnGoogle() async {
    final googleLogin = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);

    GoogleSignInAccount? signinAccount = await googleLogin.signIn();
    if (signinAccount == null) return;
    GoogleSignInAuthentication auth = await signinAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    User? user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    if (user != null) {
      this.furigana = furiganaController.text;
      this.position = positionController.text;

      if (furigana == null || furigana == "") {
        throw 'ふりがなが入力されていません';
      }

      if (position == null || position!.isEmpty) {
        throw '役職が入力されていません';
      }

      final name = user.displayName;
      final email = user.email;
      final image = user.photoURL;
      final uid = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'uid': uid,
        'image': image,
        'furigana': furigana,
        'position': position
      });
      /*
      await Navigator.of(context).pushReplacement(
          //await Navigator.push(
          //context,

          MaterialPageRoute(builder: (context) {
        //return LogoutPage(user);
        return LoginPage(user);
        */
    }
    /*
                      MaterialPageRoute(
                        builder: (context) =>
                            TopPage(user_name: user.displayName),
                      ));
                      */
  }

  //こっちを使っている
  //Firestoreへの登録作業
  Future addMyData() async {
    this.furigana = furiganaController.text;
    this.position = positionController.text;

    if (furigana == null || furigana == "") {
      throw 'ふりがなが入力されていません';
    }

    if (position == null || position!.isEmpty) {
      throw '役職が入力されていません';
    }

    // firestoreに追加
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'image': image,
      'furigana': furigana,
      'position': position
    });

    //return TopPage2;
  }
}
