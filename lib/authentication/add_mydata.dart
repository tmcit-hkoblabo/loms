import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loms2/top.dart';

class AddMyData extends ChangeNotifier {
  String? name;
  String? email;
  String? uid;
  String? furigana;
  String? position;

  Future addMyData() async {
    if (furigana == null || furigana == "") {
      throw 'タイトルが入力されていません';
    }

    if (position == null || position!.isEmpty) {
      throw '著者が入力されていません';
    }

    // firestoreに追加
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'furigana': furigana,
      'position': position
    });

    return TopPage();
  }
}
