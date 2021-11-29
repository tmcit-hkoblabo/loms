import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? name;
  String? email;
  String? description;
  String? furigana;
  String? position;
  String? number;
  String? belong;
  String? status;
  List<String> bleLocation = [];
  //String? status;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    this.email = user?.email;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    this.name = data?['name'];
    this.description = data?['description'];
    this.furigana = data?['furigana'];
    this.position = data?['position'];
    this.number = data?['number'];
    this.belong = data?['belong'];
    this.status = data?['ble_location'][0]['ble_location'].toString();

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
