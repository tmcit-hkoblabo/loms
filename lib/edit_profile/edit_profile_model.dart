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
  String? bleLocation;
  String? userStatus;
  String? updateTime;

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

  /*
  void setStatus() {
    List yourItemList = [];
    for (int i = 0; i < itemName!.length; i++)
      yourItemList.add({
        //"ble_location": bleLocation.toList()[i],
        //"status": name!.toList()[i],
        //"update_time": quantity!.toList()[i]
        "ble_location": bleLocation.toList()[i],
        "status": name!.toList()[i],
        "update_time": quantity!.toList()[i]
      });
  }
  */

  void setStatus() {
    //this.bleLocation = bleLocation;
    //this.userStatus = userStatus;
    //this.updateTime = updateTime;
    bleLocation = '5F東棟';
    this.userStatus = 'オンライン';
    this.updateTime = '9:32:32';

    notifyListeners();
  }

  bool isUpdated() {
    //return name != null || description != null;
    return description != null ||
        furigana != null ||
        position != null ||
        number != null ||
        belong != null ||
        bleLocation != null ||
        userStatus != null ||
        updateTime != null;
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
      'status': [
        {
          'ble_location': bleLocation,
          'user_status': userStatus,
          'update_time': updateTime
        }, //0
        {
          'ble_location': bleLocation,
          'user_status': userStatus,
          'update_time': updateTime
        }, //1
        {
          'ble_location': bleLocation,
          'user_status': userStatus,
          'update_time': updateTime
        }, //2
      ],
      'ble_location': bleLocation,
    });
  }
}
