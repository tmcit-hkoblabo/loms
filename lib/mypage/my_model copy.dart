import 'dart:math';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:loms2/mypage/my_ble.dart';

//import 'dart:collection';
//import 'dart:math';

class BleList {
  String? uuid;
  int? rssi;
  BleList.scanResult(ScanResult result) {
    //_rawPeripheral = result.device;
    uuid = result.device.id.id;
    rssi = result.rssi;
  }
}

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
  String? ble;
  String? device;
  //List<String> bleLocation = [];
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
    //SharedPreferences prefs = await SharedPreferences.getInstance();
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
    //this.ble = prefs.getString('countData');
    notifyListeners();
  }

  Future scanDevices() async {
    //FlutterBlue.instance.startScan(
    //  timeout: Duration(milliseconds: 1000),
    //);
    // You could stop the scan as well, after finding what you need or just got every device on the list

    //FlutterBlue.instance.stopScan();

    //device = FlutterBlue.instance.scanResults;
    //print('${device.name} found! rssi: ${scanResult.rssi}');
    FlutterBlue.instance
        .scan(timeout: Duration(seconds: 1))
        .listen((scanResult) async {
      /*
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bleData = json.encode({
        'device_name': scanResult.device.name.toString(),
        'rssi': scanResult.rssi.toInt(),
      });
      await prefs.setString('bleData', bleData);
      */

      //FlutterBlue.instance.stopScan();

      List<Map<String, dynamic>> list5 = [
        {
          "device_name": scanResult.device.name.toString(),
          "rssi": scanResult.rssi.toInt()
        },
      ];

      //var list6 = [];
      //var list7 = list5.remove(
      //    list5.where((ble) => ble["device_name"]!.contains('5F_')));
      /*
      if (list5.where((ble) => ble["device_name"]!.contains('5F_'))) {
        list5.clear();
        //print('bad');
      } else {
        list6.add(list5.where((ble) => ble["device_name"]!.contains('5F_')));
        //print('sucess');
      }
      */

      //print(list6);

      var list6 = list5.where((ble) => ble["device_name"]!.contains('5F_'));
      //var list7 = list6.where((ble) => ble["device_name"].contains('East'));
      //var list7 = list6.where((ble) => ble["rssi"]!.reduce(max));
      var list7 = list6.toList()

        ///  ..sort((a, b) => a['rssi'].compareTo(b['rssi']));
        ..sort((a, b) => a['rssi'].compareTo(b['rssi']));

      //var list8 = list6.toList()..where((ble) => ble["rssi"].redece(max));

      ///var list8 = list6.toList()..where((ble) => ble["rssi"].redece(max));
      //var list8 = list7.where((ble) => ble["rssi"].sort());

      if (list7.isNotEmpty) {
        print(list7);
      } else {
        list7.clear();
        //print('the list is empty');
      }

      //var list8 = list7.where((ble) => ble["rssi"].reduce(max));
      //var list9 = list7.reduce(max);
      //var list8 = list7.removeRange(1, list7.length);
      //list7.map((ble) => BleList.scanResult(ble));

      /*
      if (list8.isNotEmpty) {
        print(list8);
      } else {
        print('the list is empty');
      }
      */

      //print('updateSharedPrefrences: $myClocks');
      //var list7 = list6.where((ble) => ble["rssi"].first);
      ///print(list8);
      //print(scanResult.device.name.runtimeType);
      //print(list7.first);
      //print('個数は ${list6.length}');
      //notifyListeners();
    });

    //return FlutterBlue.instance.scanResults
    //    .where((scanResult) => scanResult.contains('5F'));
    //.listen((scanResult) {
    //   print("${scanResult.uuid.toString()}");
    //.where((scanResult) => scanResult.device.name.contains('5F'));
    //onDone: FlutterBlue.instance.stopScan);
    //FlutterBlue.instance.stopScan();
    //print(over21s);
    /*
    FlutterBlue.instance
      ..scanResults.listen((results) {
        print('123');
        // do something with scan results
        for (ScanResult r in results) {
          //var list = [r.device.name, r.rssi];
          //List blelist = [BleList(r.device.name, r.rssi)];
          //
          //final map2 = SplayTreeMap();
          //final map1 = <int, String>{r.rssi: r.device.name};
          //final map1 = {r.device.name: r.rssi};

          List<Map<String, dynamic>> list5 = [
            {"device_name": r.device.name, "rssi": r.rssi},
          ];
          //list.sort((a, b) => a.compareTo(b));
          //list5.where((ble) => ble["device_name"].contains('5F_'));
          //blelist.sort((a, b) => b.rssi.compareTo(a.rssi));

          //var mappedFruits = list.map((fruit) => 'I love $fruit').toList();
          //print(mappedFruits);

          //print('${r.device.name} found! rssi: ${r.rssi}');
          //print('出力2');

          //print(list);
          //map2.addAll(map1);
          //final map2 = Map.from(map1)
          //  ..removeWhere((a, b) => !a.startsWith("5F_"));
          print(list5.contains('5F'));
          //print('end');
          //print(list5);
        }

        print('456');
      });
      */
    FlutterBlue.instance.stopScan();
    print('end');
    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
