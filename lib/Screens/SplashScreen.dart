// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/LoginPage.dart';
import 'Dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoginValue = false;

  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus = "Unknown";
  var contentmessage = "Unknown";

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          break;
        case DataConnectionStatus.disconnected:
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Please Check Internet Connection...")));
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void isLogin() async {
    if (FirebaseAuth.instance.currentUser!=null) {
      if (FirebaseAuth.instance.currentUser.emailVerified) {
        setState(() {
          isLoginValue = true;
        });
      } else {
        setState(() {
          isLoginValue = false;
        });
      }
    }

    else {
      setState(() {
        isLoginValue = false;
      });
    }
  }
  @override
  void initState() {
    checkConnection(context);
    isLogin();
    Timer(Duration(seconds: 3),
        () => Get.to(isLoginValue ? DashBoard(0,"History") : LoginPage()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
