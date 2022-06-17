import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/Dashboard.dart';



class emailverify extends StatefulWidget {
  const emailverify({Key key}) : super(key: key);

  @override
  State<emailverify> createState() => _emailverifyState();
}

class _emailverifyState extends State<emailverify> {

  bool _isEmailVerified=false;
  Timer timer;
  bool canResendEmail=true;
  String phone;
  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    if (!_isEmailVerified) {
      sendVerificationEmail();
      timer=Timer.periodic(Duration(seconds: 1),(_)=> checkEmailVerified());
    }
  }

  Future checkEmailVerified()
  async{
    await FirebaseAuth.instance.currentUser.reload();
    setState((){
      _isEmailVerified=FirebaseAuth.instance.currentUser.emailVerified;
    });

  }
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();
      setState((){
        canResendEmail=false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState((){
        canResendEmail=true;
      });
    } catch (e) {
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
      );
      print(e);

    }
  }


  @override
  Widget build(BuildContext context)=> _isEmailVerified ?
  DashBoard(0, "History"): Scaffold(
    appBar: AppBar(title: Text('Verify Email '),),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Text('Verification mail has been sent to your email')
        ),
        SizedBox(height: 20,),
        RaisedButton(onPressed:canResendEmail ? sendVerificationEmail:(){},textColor: Colors.white,
          color: Colors.indigo[200],
        child: Text('Resend email'),
        )
      ],
    ),
  );
}
