//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loms2/welcome_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:loms2/authentication/add_mydata.dart';

/*
class TopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopPage();
}
*/

// ignore: must_be_immutable
class TopPage2 extends StatelessWidget {
//class _TopPage extends State<TopPage> {

  final User user;
  //TopPage(this.user, {User? user});
  TopPage2(this.user);

  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  late GoogleSignInAccount googleUser;
  late GoogleSignInAuthentication googleAuth;
  late AuthCredential credential;

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //final _nameController = TextEditingController();
  // ignore: non_constant_identifier_names
  //tring? user_name;
  // ignore: non_constant_identifier_names
  //TopPage({Key? key, user_name}) : super(key: key);
  //late String _myEmail;
  //get name => null;
  /*
  Future<String> getData(
      String collection, String documentId, String field) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc().get();
    Map<String, dynamic> record = docSnapshot.data as Map<String, dynamic>;
    return record[field];
  }*/

  // ignore: unused_element
  //Future _getPreferences() async {
  //var preferences = await SharedPreferences.getInstance();
  // SharedPreferencesから値を取得.
  // keyが存在しない場合はnullを返す.
  // ignore: unnecessary_statements
  //preferences.getString('myName') ?? '';
  //final myName = preferences.getString('myName') ?? '';
  //final myEmail = preferences.getString('myEmail') ?? '';
  // ignore: unnecessary_statements
  //preferences.getString('myEmail') ?? '';
  //}

  /*
  @override
  void initState() {
    super.initState();
    /*
    getName().then((value) {
      setState(() {
        _myName = value;
      });
    });
    */
    getName();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TopPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ログインが完了しました'),
            Text('ようこそ ${user.displayName} さん'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            /*
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
            */
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("User Email"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                //backgroundImage: NetworkImage(image),
              ),
              /*
              currentAccountPicture: ClipOval(
                child: Image(
                    image: AssetImage('loms2/assets/kumamon.jpg'),
                    fit: BoxFit.cover),
              ),
              accountName: Text('Belajar Flutter'),
              accountEmail: Text('hallo@belajarflutter.com'),*/
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
                //await googleLogin.signIn();
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return WelcomePage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
  /*
  getName() async {
    //SharedPreferences prefs = await _prefs;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _myName = prefs.getString('shared_name') ?? '';
  }
  */
}
