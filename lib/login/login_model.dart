import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final furiganaController = TextEditingController();
  final positionController = TextEditingController();
  final numberController = TextEditingController();
  final belongController = TextEditingController();

  String? name;
  String? email;
  String? uid;
  String? image;
  String? furigana;
  String? position;
  String? number;
  String? belong;
  //String? bleLocation;
  String? status;
  String? password;
  List<String> bleLocation = ['', '', '', '', ''];

  bool isLoading = false;

  //var bleLocation = ['東棟5F', '中央棟5F'];

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

  void setNumber(String number) {
    this.number = number;
    this.belong = null;
    notifyListeners();
  }

  void setBelong(String belong) {
    this.belong = belong;
    this.number = null;
    notifyListeners();
  }

  void setBleLocation(/*String bleLocation*/) {
    //this.bleLocation = '東棟5F(試験的)';
    //var array = new List();
    bleLocation.insert(0, '1'); // [2, 4, 6, 8]
    this.status = bleLocation[0];
    //var bleLocation = ['東棟5F', '中央棟5F'];
    notifyListeners();
  }

  /*
  void setStatus(/*String status*/) {
    //this.bleLocation = bleLocation;
    //var bleLocation = ['a', 'c'];
    //this.bleLocation = '東棟5F(試験的)';
    var status = new Map();
    status['ble_location'] = '東棟5F';
    status['user_status'] = 'オンライン';
    status['update_time'] = '10:37:32';

    notifyListeners();
  }
  */

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
        'position': position,
        //'number': number,
        //'belong': belong
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
    this.number = numberController.text;
    this.belong = belongController.text;

    if (furigana == null || furigana == "") {
      throw 'ふりがなが入力されていません';
    }

    if (position == null || position!.isEmpty) {
      throw '役職が入力されていません';
    }

    if (position == '学生' && (number == null || number == "")) {
      throw '学生番号が入力されていません';
    }

    if (position == '教員' && (belong == null || belong == "")) {
      throw '所属学科が入力されていません';
    }

    // firestoreに追加
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'image': image,
      'furigana': furigana,
      'position': position,
      'number': number,
      'belong': belong,
      //'ble_location': bleLocation,
      'status': status,
      'ble_location': [
        {
          'ble_location': bleLocation[0],
        }, //0
        {
          'ble_location': bleLocation[1],
        }, //1
        {
          'ble_location': bleLocation[2],
        }, //2
      ]
    });

    //return TopPage2;
  }
}
