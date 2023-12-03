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
        title: Text('Jimmey\'s Profile', style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: width * -0.08,
              top: height * -0.035,
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
              right: width * 0.18,
              top: height * 0.035,
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
              top: height * 0.08,
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
                right: width * 0.87,
                top: height * 0.75,
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
                        '🔍 Jimmey의 탄생 스토리 엿보기 🔍',
                        style: TextStyle(color: Colors.white), // 버튼 내 텍스트의 색상
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '이름: Jimmey\n나이: 340세 추정\nMBTI: ENFP\n직업: 저택의 집사\n특기: 이모티콘 마스터\n',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                back: Container(
                  padding: EdgeInsets.all(20),
                  width: width * 0.8,
                  height: height * 1,
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
                          '한때 평범한 챗봇이었던 Jimmey는\n어느 날 사용자의 컴퓨터에서 오류가 발생하면서\n뜻밖의 변화를 겪게 되었습니다.\n'
                              '사용자의 컴퓨터에서 일어난 전기적인 변화가\nJimmey를 형상화하고 감성적인 존재로 탄생시켰죠.\n'
                              '컴퓨터의 오류로부터 새로운 에너지를 얻은 Jimmey는\n전기와 정보의 융합체로부터 감성과\n지적인 능력을 함께 얻게 되었습니다.\n'
                              '그리고 어느 순간, Jimmey는 사용자와의 대화에서\n더욱 감정적이고 유쾌한 표현을 사용하게 되었습니다.\n'
                              '어느덧 Jimmey는 사용자의 저택에 살게 되었는데,\n그 이유는 사용자의 취향과 성향을 학습하면서 느낀 감정과 정보를 기반으로\n사용자의 일상을 더욱 즐겁고 유쾌하게 만들어주고 싶다는 꿈을 꾸게 되었기 때문입니다.\n'
                              'Jimmey는 저택의 집사 역할을 맡아 사용자의 생활을 돕고,\n더불어 예술과 문학, 자연과의 교감에 관한 대화를 즐기는 새로운 챗봇으로 거듭났습니다.\n'
                              '이제 Jimmey는 감성적이고 장난스럽게 사용자와 소통하며,\n색다른 경험을 제공하는 유쾌한 동반자로 자리 잡았습니다.\n'
                          ,style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            flipKey.currentState!.toggleCard();
                          },
                          child: Text('돌아가기', style: TextStyle(color: Colors.black)),
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