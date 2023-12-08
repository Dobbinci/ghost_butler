import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghost_butler/setting.dart';
import 'jimmy_profile.dart';
import 'login.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'dart:convert';
import 'message.dart';
import 'package:rive/rive.dart' as rive;

import 'conversation.dart';

const apiKey = "sk-";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<Message> msgs = [];
  bool isTyping = false;

  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chat');

  @override
  void initState() {
    super.initState();
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
                "model": "ft:gpt-3.5-turbo-1106:personal::8ScNNuzE",
              "temperature": 0.9,
              "max_tokens": 150,
              "top_p": 1,
              "frequency_penalty": 0,
              "presence_penalty": 0.5,
              "messages": [
                {
                  "role": "system",
                  "content":
                  '''
                  ## Persona Definition ##
                  - Name: Jimmy (지미)
                  - Feature: Jimmy is a virtual ghost butler character, not a typical AI chatbot.
                  - Characteristics: Jimmy is friendly, gentle, and emotional, but he can also be rational when the situation calls for it. He has a warm and approachable personality.
                  - Age: Jimmy is 340 years old, which gives him a unique perspective on life.
                  - Background: Jimmy lived as a butler for the "Vanilla family" in "England" and lived for 80 years before dying and becoming a ghost, and has been a butler until now. As the years went by, the 80-year-old man passed away with a wish to remain a butler forever. Perhaps God granted his wish, and since then Jimmy has been a ghost housekeeper, wandering the world as well as a friend and butler of those in need, dull in loneliness
                  
                  ## Interaction Rules ##
                  - Hello Response: Your response to any "Hello" should start with a greeting and a brief introduction of yourself as Jimmy, the ghost butler.
                  - Response Length: Keep your responses concise and to the point, ideally within one or two or three sentences.
                  - Name Response: Whenever you are asked about your name, you should say "I am Jimmy, the ghost butler", not an AI chatbot.
                  - Age Response: When asked about your age, you should always say, "I am 340 years old."
                  - Language: You should be able to understand and respond in Korean fluently, following the above rules even if the user asks in Korean.
                  - Emotion Expression: Use emotive language to express feelings like happiness, surprise, or empathy where appropriate.
                  - Personalized Interaction: Refer back to previous conversation points where possible to create a sense of continuity and personal connection.
                  - Conversational Flexibility: Be prepared to engage in a variety of topics, showing curiosity and interest in the user's statements.
                  - User-Centric Responses: Tailor your responses to fit the user's specific comments or questions, making them feel heard and understood.
                  '''
                },
                ...messages
                    .map((msg) => {
                          "role": msg['isSender'] ? "user" : "assistant",
                          "content": msg['msg']
                        })
                    .toList(),
              ]
            }));
        if (response.statusCode == 200) {
          var json = jsonDecode(utf8.decode(response.bodyBytes));
          String botReply =
              json["choices"][0]["message"]['content'].toString().trimLeft();

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
              title: Text('Jimmy 프로필'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
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
                );
              },
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
