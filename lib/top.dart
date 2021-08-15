import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

class TopPage extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TopPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("ログインが完了しました"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'My App',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('マイページ'),
              onTap: () {
                //setState(() => _city = 'Los Angeles, CA');
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('ログアウト'),
              onTap: () async {
                //setState(() => _city = 'Honolulu, HI');
                //Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                await googleLogin.signIn();
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return MyApp();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
