import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost_butler/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Google sign-in
  Future<UserCredential> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);
    DocumentSnapshot documentSnapshot = await docRef.get();

    if (documentSnapshot.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      //user document 생성
      FirebaseFirestore.instance
          .collection('user')
          .doc(user?.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          //make document in user collection
          FirebaseFirestore.instance.collection('user').doc(user?.uid).set({
            'uid': user?.uid,
            'email': user?.email,
          });
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpPage(),
        ),
      );
    }

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //moon
              Positioned(
                  right: width * -0.08,
                  top: height * -0.035,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(247, 229, 134, 1.0)),
                  )),
              //crater of moon
              Positioned(
                  right: width * 0.18,
                  top: height * 0.035,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(243, 210, 36, 1.0)),
                  )),
              //crater of moon
              Positioned(
                  right: width * 0.01,
                  top: height * 0.08,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(243, 210, 36, 1.0)),
                  )),
              //cloud 1
              Positioned(
                  right: width * 0.67,
                  top: height * 0.05,
                  child: Container(
                    child: Lottie.asset('assets/lottie/cloud.json'),
                    width: 120,
                    height: 120,
                  )),
              //cloud 2
              Positioned(
                  right: width * -0.2,
                  top: height * 0.35,
                  child: Container(
                    child: Lottie.asset('assets/lottie/cloud.json'),
                    width: 150,
                    height: 150,
                  )),
              //cloud 3
              Positioned(
                  right: width * 0.4,
                  top: height * 0.75,
                  child: Container(
                    child: Lottie.asset('assets/lottie/cloud.json'),
                    width: 160,
                    height: 160,
                  )),
              //logo
              Positioned(
                  top: height * 0.2,
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/ghost_butler_logo.png'),
                  )),
              //button for google sign-in
              Positioned(
                  top: height * 0.7,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(150, 50)),
                      ),
                      onPressed: () {
                        googleSignIn();
                      },
                      child: Row(

                        children: <Widget>[
                          Image.asset('assets/images/google_logo.png', height: 25.0),
                          SizedBox(width: 8.0),
                          Text("Sign in with Google",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                        ],
                      ))),
            ],
          )),
        ],
      ),
    );
  }
}
