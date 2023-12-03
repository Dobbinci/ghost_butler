import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghost_butler/setting.dart';
import 'jimmey_profile.dart';
import 'login.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'dart:convert';
import 'message.dart';
import 'package:rive/rive.dart' as rive;

import 'conversation.dart';

const apiKey = "sk"

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<Message> msgs = [];
  bool isTyping = false;

  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chat');

  @override
  void initState() {
    super.initState();
    //_subscribeToMessages();
  }

  void _subscribeToMessages() async {
    String username = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference document = _chatCollection.doc(username);
    DocumentSnapshot documentSnapshot = await document.get();

    var chatInfo = documentSnapshot.get('chat_info') as List<dynamic> ?? [];
    final List<Message> messages = chatInfo.map((data) {
      return Message(
        isSender: data['isSender'] ?? false,
        msg: data['msg'] ?? '',
        time: data['time'] ?? '',
        name: data['name'] ?? '',
      );
    }).toList();

    for (var a in messages) {
      print(a.msg);
      print("hello");
    }

    setState(() {
      msgs = messages.reversed.toList();
    });

    // 사용자의 대화 기록을 가져와 GPT에 전달
    List<String> userMessages =
        messages.where((msg) => msg.isSender).map((msg) => msg.msg).toList();

    // GPT 모델에 이전 대화를 전달하고 응답을 받음
    var response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode({
        "model": "ft:gpt-3.5-turbo-0613:personal::8QUOgwkd",
        "messages": userMessages
            .map((userMsg) => {"role": "user", "content": userMsg})
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      String botReply =
          json["choices"][0]["message"]["content"].toString().trimLeft();

      setState(() {
        isTyping = false;
        msgs.insert(
          0,
          Message(
            isSender: false,
            msg: botReply,
            time: DateTime.now().toString(),
            name: 'ChatBot',
          ),
        );
      });
    }
  }

  void sendMsg() async {
    String text = controller.text;
    controller.clear();

    try {
      if (text.isNotEmpty) {
        String username = FirebaseAuth.instance.currentUser!.uid;

        // 현재 유저에 대한 문서 가져오기 또는 생성
        DocumentReference userDocRef = _chatCollection.doc(username);

        // 기존 메세지 가져오기
        DocumentSnapshot userDoc = await userDocRef.get();
        List<dynamic> messages =
            userDoc.exists ? (userDoc['chat_info'] as List<dynamic>) : [];

        // 새 메세지 추가
        messages.add({
          'isSender': true,
          'msg': text,
          'time': DateTime.now().toString(),
        });

        // 업데이트된 메세지로 문서 업데이트
        await userDocRef.set({'chat_info': messages}, SetOptions(merge: true));

        setState(() {
          msgs.insert(
            0,
            Message(
              isSender: true,
              msg: text,
              time: DateTime.now().toString(),
              name: 'YourUsername',
            ),
          );
          isTyping = true;
        });

        // GPT 모델에 이전 대화를 전달하고 응답을 받음
        var response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json; charset=utf-8",
          },
          body: jsonEncode({
            "model": "ft:gpt-3.5-turbo-0613:personal::8MsGwaSy",
            "messages": messages
                .map((msg) => {
                      "role": msg['isSender'] ? "user" : "assistant",
                      "content": msg['msg']
                    })
                .toList(),
          }),
        );

        if (response.statusCode == 200) {
          var json = jsonDecode(utf8.decode(response.bodyBytes));
          String botReply =
              json["choices"][0]["message"]["content"].toString().trimLeft();

          // 새로운 챗봇 메세지 추가
          messages.add({
            'isSender': false,
            'msg': botReply,
            'time': DateTime.now().toString(),
          });

          // 업데이트된 메세지로 문서 업데이트
          await userDocRef
              .set({'chat_info': messages}, SetOptions(merge: true));

          setState(() {
            isTyping = false;
            msgs.insert(
              0,
              Message(
                isSender: false,
                msg: botReply,
                time: DateTime.now().toString(),
                name: 'ChatBot',
              ),
            );
          });
        }
      }
    } catch (e) {
      final errorMessage = "오류 발생: $e";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 1, 19, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //auth에서 가저온 정보 넣기
            UserAccountsDrawerHeader(
                accountName: Text('Vinci'),
                accountEmail: Text('vinci@handong.ac.kr')),
            ListTile(
              leading: Icon(
                Icons.person,
              ),
              title: Text('Jimmey'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );              },
            ),
            ListTile(
              leading: Icon(
                Icons.mic_none,
              ),
              title: Text('대화 모드'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConversationPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text('환경설정'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ),
                );              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: Text('로그아웃'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1,
              child: RiveAnimation.asset(
                'assets/rive/ghost.riv',
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: msgs.length > 2 ? 2 : msgs.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              final message = msgs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: isTyping && index == 0
                    ? Column(
                        children: [
                          BubbleNormal(
                            text: message.msg,
                            isSender: true,
                            color: Colors.blue.shade100,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Typing..."),
                            ),
                          )
                        ],
                      )
                    : BubbleNormal(
                        text: message.msg,
                        isSender: message.isSender,
                        color: message.isSender
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                      ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: controller,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            sendMsg();
                          },
                          textInputAction: TextInputAction.send,
                          showCursor: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter text",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    sendMsg();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
