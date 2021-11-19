import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  //EditProfileModel(this.name, this.description, String position) {
  EditProfileModel(this.description, this.furigana, this.position, this.number,
      this.belong) {
    //nameController.text = name.toString();
    descriptionController.text = description.toString();
    furiganaController.text = furigana.toString();
    positionController.text = position.toString();
    numberController.text = number.toString();
    belongController.text = belong.toString();
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final furiganaController = TextEditingController();
  final positionController = TextEditingController();
  final numberController = TextEditingController();
  final belongController = TextEditingController();

  String? name;
  String? description;
  String? furigana;
  String? position;
  String? number;
  String? belong;

  //おそらく使わない
  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setDescription(String description) {
    this.description = description;
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
    belong = null;
    notifyListeners();
  }

  void setBelong(String belong) {
    this.belong = belong;
    number = null;
    notifyListeners();
  }

  bool isUpdated() {
    //return name != null || description != null;
    return description != null ||
        furigana != null ||
        position != null ||
        number != null ||
        belong != null;
  }

  Future update() async {
    //this.name = nameController.text;
    this.description = descriptionController.text;
    this.furigana = furiganaController.text;
    this.position = positionController.text;
    this.number = numberController.text;
    this.belong = belongController.text;

    // firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      //'name': name,
      'description': description,
      'furigana': furigana,
      'position': position,
      'number': number,
      'belong': belong,
    });
  }
}
