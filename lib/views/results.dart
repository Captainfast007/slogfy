import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/widget.dart';
import 'home.dart';


class Results extends StatefulWidget {
  final int total, correct, incorrect;
  Results({this.incorrect, this.total, this.correct});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.to(Home());
            },
            icon: Icon(
              Icons.arrow_back,
            )),
        title: AppLogo(),
        centerTitle: true,
        backgroundColor: Color(0xffff2d55),
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Scores",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text(
                "${widget.correct}/ ${widget.total}",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 24),
              //   child: Text(
              //       "you answered ${widget.correct} answers correctly and ${widget.incorrect} answeres incorrectly",
              //   textAlign: TextAlign.center,),

              // ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                      color: Color(0xffff2d55),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Go to home",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
