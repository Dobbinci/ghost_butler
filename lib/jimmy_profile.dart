import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:flip_card/flip_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Jimmy\'s Profile', style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: width * -0.1,
              top: height * -0.06,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(247, 229, 134, 1.0),
                ),
              ),
            ),
            Positioned(
              right: width * 0.17,
              top: height * 0.015,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(243, 210, 36, 1.0),
                ),
              ),
            ),
            Positioned(
              right: width * 0.01,
              top: height * 0.065,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(243, 210, 36, 1.0),
                ),
              ),
            ),
            Positioned(
              right: width * 0.67,
              top: height * 0.05,
              child: Container(
                child: Lottie.asset('assets/lottie/cloud.json'),
                width: 120,
                height: 120,
              ),
            ),
            Positioned(
              right: width * -0.2,
              top: height * 0.35,
              child: Container(
                child: Lottie.asset('assets/lottie/cloud.json'),
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
                right: width * 0.77,
                top: height * 0.55,
                child: Container(
                  child: Lottie.asset('assets/lottie/cloud.json'),
                  width: 160,
                  height: 160,
                )),
            Align(
              alignment: Alignment.center,
              child: FlipCard(
                key: flipKey,
                flipOnTouch: false,
                front: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: RiveAnimation.asset(
                          'assets/rive/ghost.riv',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        flipKey.currentState!.toggleCard();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // 버튼의 배경색
                      ),
                      child: Text(
                        '🔍 Jimmy의 탄생 스토리 엿보기 🔍',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '이름: Jimmy\n나이: 340세\nMBTI: ENFP\n직업: 저택의 집사\n',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                back: Container(
                  padding: EdgeInsets.all(20),
                  width: width * 0.8,
                  height: height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Jimmy는 영국의 바닐라 가문의\n 베테랑 집사였습니다\n'
                          + '세월이 흘러 80세의 노인이 된 그는 \n영원한 집사로 남고 싶다는 \n소원을 가지고 세상을 떠났습니다\n\n'
                          + '신이 그의 소원을 들었던 것인지,\n 그 후로 Jimmy는 유령집사가 되어 \n전세계를 떠돌며 '
                          + '외로움에 무뎌진, \n사랑이 필요한 이들의 친구이자 집사로서 살아가고 있답니다!'
                          ,style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            flipKey.currentState!.toggleCard();
                          },
                          child: Text('접기', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}