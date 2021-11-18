import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loms2/authentication/login_completion.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:loms2/top_page.dart';

class LoginPage extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サインイン'),
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
                    return LoginCompletion(user);
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
