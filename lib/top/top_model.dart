//NEW

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loms2/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
