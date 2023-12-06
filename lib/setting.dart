import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool pushNotificationEnabled = true; // 푸시 알림 활성화 여부

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(13, 1, 19, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('환경설정', style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              '대화 기록 삭제',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // 대화 기록 삭제 로직 추가
              // 예: showDialog, 데이터 삭제 등
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('대화 기록 삭제'),
                    content: Text('대화 기록을 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          // 삭제 로직 추가
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            DocumentReference chatRef =
                            FirebaseFirestore.instance.collection('chat').doc(user.uid);
                            await chatRef.delete();
                          }
                          Navigator.pop(context);
                        },
                        child: Text('확인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider( // Separator
            color: Colors.white,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              '푸시 알림 설정',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Switch(
              value: pushNotificationEnabled,
              onChanged: (value) {
                setState(() {
                  pushNotificationEnabled = value;
                });
              },
            ),
          ),
          Divider( // Separator
            color: Colors.white,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              'Version: 1.0.0',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}