import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghost_butler/home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: '성별',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '성별을 입력하세요';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12.0),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Age',
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
                          if (!snapshot.exists) {
                            //make document in user collection
                            await FirebaseFirestore.instance.collection('user').doc(uid).set({
                              'username': _usernameController.text,
                              'age': _ageController.text,
                              'gender': _genderController.text,
                            });
                          }
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
