import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/create_quiz.dart';
import '../views/home.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var userReference;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    return userReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 55, 20, 0),
              child: GestureDetector(
                onTap: () {
                  Get.to(Home());
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  child: Card(
                    color: Color(0xffff2d55),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Solve Quiz",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['isTeacher']) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(CreateQuiz());
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            child: Card(
                              color: Color(0xffff2d55),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      " Create Quiz",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
