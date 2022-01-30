//import 'dart:js';
import 'dart:math';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    //Map<String, ScanResult> scanResults = new Map();
    BleWave bleWave = BleWave();
    Map<int, String> scanResults = new Map();
    //var scanResults = new Map();

    FlutterBlue.instance
        .scan(timeout: Duration(seconds: 1))
        .listen((scanResult) async {
      if (scanResult.device.name.toString().contains('5F_')) {
        //scanResults[scanResult.device.name] = scanResult;
        scanResults[scanResult.rssi] = scanResult.device.name;
        //この時点で別のところに作ったリストもしくはマップにデータを追加する処理を書けばいい
        //BleWave(bleWave.bleResults: scanResults);
        scanResults.addAll(bleWave.bleResults);
        //scanResults.addAll(setMap().bleResults);
        /*
        print('順位変動前:');
        print(scanResults);

        var thevalue = 0;
        var thekey;

        scanResults.forEach((k, v) {
          scanResults.values.map((e) => k).reduce(max);
          if (k > thevalue) {
            thevalue = k;
            thekey = v;
          }
        });
        */

        //scanResults.removeWhere((key, value) => key < key.reduce(max));

        //print(thekey);
        //print(scanResults);
        //print(
        //    "found! Attempting to connect" + scanResult.device.name.toString());
      } else {
        scanResults.clear();
      }

      /*
      for (var key in scanResults.keys) {
        print(key);
      }
      */

      /*
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bleData = json.encode({
        'device_name': scanResult.device.name.toString(),
        'rssi': scanResult.rssi.toInt(),
      });
      await prefs.setString('bleData', bleData);
      */

      //FlutterBlue.instance.stopScan();

      var list5 = [
        //List<Map<String, dynamic>> list5 = [
        {
          'rssi': scanResult.rssi.toInt(),
          'device_name': scanResult.device.name.toString()
        },
      ];

      /*
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bleData = json.encode({list5});
      await prefs.setString('bleData', bleData);
      */

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

      //本物
      /*
      var list6 = list5;
      var pairString = (e) =>
          "${e['rssi'].toString().padLeft(8, '0')}" + "${e['device_name']}";
      list6.sort((a, b) => pairString(a).compareTo(pairString(b)));
      list6.asMap().forEach((key, value) => print("$key: $value"));
      */

      /*
      var list6 = list5
          .where((ble) => ble["device_name"].contains('5F_'))
          .toList()
        ..sort((a, b) => a['rssi'].compareTo(b['rssi']));
      //..where((ble) => ble["rssi"].redece(max));
      */

      ///var list6 = list5.where((ble) => ble["device_name"]!.contains('5F_'));
      //var list7 = list6.where((ble) => ble["device_name"].contains('East'));
      //var list7 = list6.where((ble) => ble["rssi"]!.reduce(max));
      ///var list7 = list6.toList()
      ///  ..sort((a, b) => a['rssi'].compareTo(b['rssi']));

      //var list8 = list6.toList()..where((ble) => ble["rssi"].redece(max));

      ///var list8 = list6.toList()..where((ble) => ble["rssi"].redece(max));
      //var list8 = list7.where((ble) => ble["rssi"].sort());

      //これが本物
      /*
      if (list6.isNotEmpty) {
        print(list6);
      } else {
        list6.clear();
        //print('the list is empty');
      }
      */

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
    print(bleWave.bleResults);

    //var list10 = [];
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList("bleData");

    print('result:$result');
    */
    /*
    if (result != null) {
      // ②デコード→③MapオブジェクトをClockModelに代入→④リストに変換
      list10 =
          result.map((f) => ClockModel.fromJson(json.decode(f))).toList();
    } else {
      // 必要に応じて初期化
    }
    */

    notifyListeners();
  }

  Future setMap() async {
    Map<int, String> bleResults = new Map();
    print(bleResults);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

class BleWave {
  String? name;
  String? rssi;

  Map<int, String> bleResults = new Map();
  //var bleResults = '123';
  /*
  BleWave.fromJson(Map<String, dynamic> json) {
    name = json['device_name'];
    rssi = json['rssi'];
  }
  */
  Future setBle() async {
    //bleResults.reduce(max);

    //print(bleResults);
    return bleResults;
  }
}
