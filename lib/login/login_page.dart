import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loms2/login/login_model.dart';
//import 'package:loms2/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Googleアカウントでログインさせる
class SignInOnGoogle extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Googleアカウントでサインイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              text: 'Sign In with Google',
              onPressed: () async {
                GoogleSignInAccount? signinAccount = await googleLogin.signIn();
                if (signinAccount == null) return;
                GoogleSignInAuthentication auth =
                    await signinAccount.authentication;
                final OAuthCredential credential =
                    GoogleAuthProvider.credential(
                  idToken: auth.idToken,
                  accessToken: auth.accessToken,
                );
                User? user = (await FirebaseAuth.instance
                        .signInWithCredential(credential))
                    .user;
                if (user != null) {
                  await Navigator.of(context).pushReplacement(
                      //await Navigator.push(
                      //context,

                      MaterialPageRoute(builder: (context) {
                    //return LogoutPage(user);
                    return LoginPage(user);
                  }));
                  /*
                      MaterialPageRoute(
                        builder: (context) =>
                            TopPage(user_name: user.displayName),
                      ));
                      */
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

//必要情報を入力させ、Firestoreに登録する
class LoginPage extends StatelessWidget {
  final User user;
  LoginPage(this.user);
  //LoginCompletion(this.user);

  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('必要情報の入力'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Googleアカウントによる認証が完了しました。'),
                      Text('ようこそ！${user.displayName}さん'),
                      Text('必要情報の入力をお願いします。'),
                      /*
                      TextField(
                        controller: model.titleController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: model.authorController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          model.setPassword(text);
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      */
                      TextField(
                        controller: model.furiganaController,
                        decoration: InputDecoration(
                          hintText: 'ふりがな',
                        ),
                        onChanged: (text) {
                          model.setFurigana(text);
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: model.positionController,
                        decoration: InputDecoration(
                          hintText: '教員or学生',
                        ),
                        onChanged: (text) {
                          model.setPosition(text);
                        },
                        //obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (model.position == '学生')
                        TextField(
                          controller: model.numberController,
                          decoration: InputDecoration(
                            hintText: '学生番号',
                          ),
                          onChanged: (text) {
                            model.setNumber(text);
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      if (model.position == '教員')
                        TextField(
                          controller: model.belongController,
                          decoration: InputDecoration(
                            hintText: '所属学科',
                          ),
                          onChanged: (text) {
                            model.setBelong(text);
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          model.name = user.displayName;
                          model.email = user.email;
                          model.uid = user.uid;
                          model.image = user.photoURL;

                          model.startLoading();
                          // 追加の処理
                          try {
                            //await model.addMyData();
                            await model.addMyData();
                            Navigator.of(context).pop();
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: Text('ログイン'),
                      ),
                      /*
                      TextButton(
                        onPressed: () async {
                          // 画面遷移
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Text('新規登録の方はこちら'),
                      ),
                      */
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
