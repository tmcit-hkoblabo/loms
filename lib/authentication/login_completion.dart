import 'package:loms2/authentication/add_mydata.dart';
//import 'package:loms2/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:loms2/top_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
class LoginCompletion extends StatefulWidget {
  LoginCompletion(User user);

  @override
  State<StatefulWidget> createState() => _LoginCompletion();
}
*/

//class _LoginCompletion extends State<LoginCompletion> {
// ignore: must_be_immutable
class LoginCompletion extends StatelessWidget {
  final User user;
  LoginCompletion(this.user);
  //_LoginCompletion(this.user);

  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  //LoginCompletion(User user);

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //String _name;

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
                  Text('あなたのデータをシステムに登録します。'),
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
                      model.furigana = text;
                      //データをfirestoreに追加
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
                      //setName();
                      model.name = user.displayName;
                      model.email = user.email;
                      model.uid = user.uid;
                      model.image = user.photoURL;
                      // 追加の処理
                      try {
                        await model.addMyData();
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TopPage2(user)),
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

  /*setName() async {
    //setStateを使わない書き方
    //SharedPreferences prefs = await _prefs;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('永松勇人', 'shared_name');

    //setStateを使った書き方
    
    setState(() {
      //_name = prefs.getString('name');
      prefs.setString('永松勇人', 'shared_name');
    });
  }*/
}
//statefullにして
//関数を作る（displayNameで取得→その名前をsharedで保存するやつ
