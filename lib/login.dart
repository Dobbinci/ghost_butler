import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                      left: -20,
                      top: -20,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Color.fromRGBO(0, 38, 171, 1.0).withOpacity(0.2)),
                      )),
                  //moon
                  Positioned(
                      right: -30,
                      top: -10,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(247, 229, 134, 1.0)),
                      )),
                  //crater of moon
                  Positioned(
                      right: 60,
                      top: 30,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(243, 210, 36, 1.0)),
                      )),
                  //crater of moon
                  Positioned(
                      right: -20,
                      top: 50,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(243, 210, 36, 1.0)),
                      )),
                  Positioned(
                      left: 30,
                      top: 40,
                      child: Container(
                        child: Lottie.asset('assets/lottie/cloud.json'),
                        width: 120,
                        height: 120,
                      )),
                  Positioned(
                      right: 20,
                      bottom: 370,
                      child: Container(
                        child: Lottie.asset('assets/lottie/cloud.json'),
                        width: 150,
                        height: 150,
                      )),
                  Positioned(
                      right: -20,
                      top: 330,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Color.fromRGBO(0, 38, 171, 1.0).withOpacity(0.2)),
                      )),
                  Positioned(
                      left: -40,
                      bottom: -40,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Color.fromRGBO(0, 38, 171, 1.0).withOpacity(0.2)),
                      )),
                  //logo
                  Positioned(
                      top: 170,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Color.fromRGBO(0, 38, 171, 1.0).withOpacity(0.2)),
                        child: Image.asset('assets/images/ghost_butler_logo.png'),
                      )),
                  //button for google sign-in
                  Positioned(
                      bottom: 230,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          minimumSize:
                          MaterialStateProperty.all<Size>(Size(150, 50)),
                        ),
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          )
                        }, //google sign-in method 넣기
                        child: Text("Sign in with Google",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
