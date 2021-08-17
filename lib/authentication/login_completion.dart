import 'package:loms2/authentication/add_mydata.dart';
//import 'package:loms2/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:loms2/top_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCompletion extends StatelessWidget {
  final User user;
  LoginCompletion(this.user);

  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMyData>(
      create: (_) => AddMyData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('個人データの登録'),
        ),
        body: Center(
          child: Consumer<AddMyData>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("あなたのメールアドレスは ${user.email}"),

                  /*
                  TextButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      await googleLogin.signIn();
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                    child: Text('Logout', style: TextStyle(fontSize: 50)),
                  ),
                  */

                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ふりがな',
                    ),
                    onChanged: (text) {
                      model.name = user.displayName;
                      model.email = user.email;
                      model.uid = user.uid;
                      model.furigana = text;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '教員or学生',
                    ),
                    onChanged: (text) {
                      model.position = text;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 追加の処理
                      try {
                        await model.addMyData();
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopPage()),
                        );
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('登録する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
