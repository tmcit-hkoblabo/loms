import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loms2/authentication/login_page.dart';

class LogoutPage extends StatefulWidget {
  final User user;
  LogoutPage(this.user);
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("ログインが完了しました"),
            Text("${widget.user.displayName}　さん",
                style: TextStyle(fontSize: 50)),
            Text("あなたのメールアドレスは ${widget.user.email}"),
            Text("あなたのIDは ${widget.user.uid}"),
            Text("あなたのプロフィール画像は ${widget.user.photoURL}"),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await LogoutPage.googleLogin.signIn();
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              child: Text('Logout', style: TextStyle(fontSize: 50)),
            ),
            TextButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('users') // コレクションID
                    .doc('user_uid') // ドキュメントID
                    .set({'name': '鈴木', 'age': 40}); // データ
              },
              child: Text('Firestore', style: TextStyle(fontSize: 50)),
            )
          ],
        ),
      ),
    );
  }
}
