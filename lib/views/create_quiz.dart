import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

import '../Services/database.dart';
import '../widget/widget.dart';
import 'add_question.dart';


class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String quizTitle, quizDesc, quizId;

  bool isLoading = false;
  // String quizId;

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizId": quizId,
        // "quizImgUrl" : quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Get.to(AddQuestion(quizId));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: AppLogo(),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Color(0xffff2d55),
        //brightness: Brightness.li,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                  decoration: InputDecoration(hintText: "Quiz Title"),
                  onChanged: (val) {
                    quizTitle = val;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (val) =>
                      val.isEmpty ? "Enter Quiz Description" : null,
                  decoration: InputDecoration(hintText: "Quiz Description"),
                  onChanged: (val) {
                    quizDesc = val;
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    createQuiz();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Color(0xffff2d55),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Create Quiz",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
