//NEW

import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loms2/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  String _time = '';

  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    super.initState();
  }

  void _onTimer(Timer timer) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    StreamSubscription<ScanResult> scanSubscription;
    var ans = null;
    var max = 0;

    scanSubscription = FlutterBlue.instance
        .scan(timeout: Duration(seconds: 10))
        .listen((scanResult) {
      //print(scanResult.device.name.toString());
      //scanResults[scanResult.rssi] = scanResult.device.name;

      if (scanResult.device.name.toString().contains('5F_')) {
        print('順位変動前:');

        if (ans == null || scanResult.rssi > max) {
          print('abc');
          ans = scanResult.device.name;
          max = scanResult.rssi;
          print(ans);
          FirebaseFirestore.instance.collection('users').doc(uid).update(
            {
              'location': ans,
            },
          );
        }
      }
    }, onDone: () => FlutterBlue.instance.stopScan());
    /*
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm:ss');
    var formattedTime = formatter.format(now);
    setState(() => _time = formattedTime);
    */
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _time,
      style: TextStyle(
        fontSize: 60.0,
        fontFamily: 'IBMPlexMono',
      ),
    );
  }
}

class TopModel extends ChangeNotifier {
  //List<Book>? books;
  List<Ble>? books;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  //final Stream<QuerySnapshot> _usersStream =
  //    FirebaseFirestore.instance.collection('users').snapshots();

  void fetchBookList() {
    //final QuerySnapshot snapshot =
    //await FirebaseFirestore.instance.collection('books').get();
    //    await FirebaseFirestore.instance.collection('users').get();

    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
        FirebaseFirestore.instance.collection('users').snapshots();

    snapshot.listen((QuerySnapshot snapshot) {
      final List<Ble> books = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //final data = document.data()! as Map<String, dynamic>;
        final String? id = document.id;
        final String? name = data['name'];
        final String? location = data['location'];
        //final String title = data['title'];
        //final String author = data['author'];
        //final String imgURL = data['imgURL'];
        //return Book(id, title, author, imgURL);
        return Ble(id, name, location);
      }).toList();

      this.books = books;
      notifyListeners();
    });
  }

  /*
  void fetchBookList() async {
    final QuerySnapshot snapshot =
        //await FirebaseFirestore.instance.collection('books').get();
        await FirebaseFirestore.instance.collection('users').get();

    final List<Ble> books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      //final data = document.data()! as Map<String, dynamic>;
      final String? id = document.id;
      final String? name = data['name'];
      final String? location = data['location'];
      //final String title = data['title'];
      //final String author = data['author'];
      //final String imgURL = data['imgURL'];
      //return Book(id, title, author, imgURL);
      return Ble(id, name, location);
    }).toList();

    this.books = books;
    notifyListeners();
  }
  */

  Future delete(Book book) {
    return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}
