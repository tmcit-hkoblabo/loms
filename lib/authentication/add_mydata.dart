import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loms2/top_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class AddMyData extends ChangeNotifier {
  String? name;
  String? email;
  String? uid;
  String? image;
  String? furigana;
  String? position;
  /*
  saveData(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("displayName", name);
  }*/

  // ignore: unused_element
  //Future _setPreferences() async {
  //var preferences = await SharedPreferences.getInstance();
  // SharedPreferencesに値を設定.
  //preferences.setInt("test_int_key", 1);
  //preferences.setString("myName", name!);
  //preferences.setString("myEmail", email!);
  //preferences.setBool("test_bool_key", true);
  //preferences.setDouble("test_double_key", 1.0);
  //}

  Future addMyData() async {
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

    return TopPage2;
  }
}
/*
class SharedData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SharedData();
}

class _SharedData extends State<SharedData> {
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //final _nameController = TextEditingController();
  // ignore: unused_field
  late String _myName;

  @override
  void initState() {
    super.initState();
    getName().then((value) {
      setState(() {
        _myName = value;
      });
    });
  }

  Future setName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('shared_name', '永松勇人');
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
*/
