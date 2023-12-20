import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost_butler/user_content.dart';

class AppState extends ChangeNotifier {
  List<UserContent> _userContents = [];
  List<UserContent> get userContents => _userContents;

  AppState() {
    init();
  }

  Future<void> init() async {
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      _userContents = event.docs.map((doc) {
        return UserContent(
            uid: doc.data()['uid'], username: doc.data()['username'],
            age: doc.data()['age'], gender: doc.data()['gender'], email: doc.data()['email']);
      }).toList();

      notifyListeners();
    });
  }
}
