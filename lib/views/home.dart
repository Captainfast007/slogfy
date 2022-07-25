import 'package:Vikalp/views/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/Dashboard.dart';
import '../Services/database.dart';
import '../widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: quizStream,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Center(
                        child: Container(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return QuizTile(
                            noOfQuestions: snapshot.data.docs.length,
                            // imageUrl:
                            //     snapshot.data.docs[index].data()['quizImgUrl'],
                            title:
                                snapshot.data.docs[index].data()['quizTitle'],
                            description:
                                snapshot.data.docs[index].data()['quizDesc'],
                            id: snapshot.data.docs[index].data()["quizId"],
                          );
                        });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              navigator.pushAndRemoveUntil<void>(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => DashBoard(3, "Quiz")),
                ModalRoute.withName('/'),
              );
            },
            icon: Icon(Icons.arrow_back)),
        title: AppLogo(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xffff2d55),
      ),
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(QuizPlay(id));
      },
      child: Container(
        //
        padding: EdgeInsets.only(bottom: 8, right: 8, left: 8, top: 8),
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 231, 80, 108),
                    Color.fromARGB(255, 50, 53, 53)
                  ],
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? 'default value',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description ?? 'default value',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
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
