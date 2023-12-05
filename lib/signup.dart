import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghost_butler/home.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;

  final List<String> _genderOptions = ['남성', '여성'];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 1, 19, 1.0),
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.05),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "회원가입",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: '이름',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력하세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '성별',
                    ),
                    items: _genderOptions
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '성별을 선택하세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: '나이',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '나이를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        child: const Text('Sign up'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(uid)
                                .get()
                                .then((DocumentSnapshot snapshot) async {
                              if (snapshot.exists) {
                                //make document in user collection
                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(uid)
                                    .set({
                                  'username': _usernameController.text,
                                  'age': _ageController.text,
                                  'gender': _selectedGender,
                                }, SetOptions(merge: true));
                              }
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          ),

          //cloud 1
          Positioned(
              right: width * 0.67,
              top: height * 0.55,
              child: Container(
                child: Lottie.asset('assets/lottie/cloud.json'),
                width: 120,
                height: 120,
              )),
          //cloud 2
          Positioned(
              right: width * 0.01,
              top: height * 0.75,
              child: Container(
                child: Lottie.asset('assets/lottie/cloud.json'),
                width: 150,
                height: 150,
              )),
          //cloud 3
        ],
      )),
    );
  }
}
