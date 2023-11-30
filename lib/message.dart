import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  bool isSender;
  String msg;
  String time;
  String name;

  Message({
    required this.isSender,
    required this.msg,
    required this.time,
    required this.name,
  });

  Map<String, dynamic> toFirestoreMap() {
    return {
      'isSender': isSender,
      'msg': msg,
      'time': time,
      'name': name,
    };
  }

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Message(
      isSender: data['isSender'] ?? false,
      msg: data['msg'] ?? '',
      time: data['time'] ?? '',
      name: data['name'] ?? '',
    );
  }
}