import 'package:Vikalp/views/results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';


import '../Services/database.dart';
import '../models/question_model.dart';
import '../widget/widget.dart';
import '../widgets/quiz_play_widgets.dart';
import '../widgets/time_controller.dart';
import '../widgets/timer.dart';
import 'home.dart';

class QuizPlay extends StatefulWidget {
  final timeController = Get.put(TimeController());
  final String quizId;
  QuizPlay(this.quizId);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _attempted = 0;
int total = 0;

/// Stream
Stream infoStream;

class _QuizPlayState extends State<QuizPlay> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnaphot;

  bool isLoading = true;

  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value) {
      questionSnaphot = value;
      _attempted = questionSnaphot.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot.docs.length;
      widget.timeController.setTime = total * 60;

      setState(() {});
     // print("init don $total ${widget.quizId} ");

    });
    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot["question"];

    /// shuffling the options
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 218, 215, 215),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.off((Home()));
              },
              icon: Icon(
                Icons.arrow_back,
              )),centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppLogo(),
            Padding(
              padding: const EdgeInsets.only(bottom:32.0),
              child: InfoHeader(
                length: questionSnaphot.docs.length,
              ),
            ),
          ]),
          backgroundColor: Color(0xffff2d55),
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    questionSnaphot.docs == null
                        ? Container(
                            child: Center(
                              child: Text("No Data"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: questionSnaphot.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              print(questionSnaphot.docs.length);
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnaphot.docs[index]),
                                index: index,
                              );
                            })
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffff2d55),
            child: Icon(Icons.check),
            onPressed: () {
              Get.to((Results(
                  correct: _correct, incorrect: _incorrect, total: total)));
            }));
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return ProgressBar();
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({@required this.questionModel, @required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Text(
                "Q${widget.index + 1}). ${widget.questionModel.question}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Divider(
              color: Colors.grey,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  ///correct
                  if (widget.questionModel.option1 ==
                      widget.questionModel.correctOption) {
                    setState(() {
                      optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _attempted = _attempted + 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _attempted = _attempted - 1;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(136, 230, 226, 226),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: OptionTile(
                      option: "A",
                      description: "${widget.questionModel.option1}",
                      correctAnswer: widget.questionModel.correctOption,
                      optionSelected: optionSelected,
                    )),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  ///correct
                  if (widget.questionModel.option2 ==
                      widget.questionModel.correctOption) {
                    setState(() {
                      optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _attempted = _attempted - 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _attempted = _attempted + 1;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(136, 230, 226, 226),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: OptionTile(
                    option: "B",
                    description: "${widget.questionModel.option2}",
                    correctAnswer: widget.questionModel.correctOption,
                    optionSelected: optionSelected,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  ///correct
                  if (widget.questionModel.option3 ==
                      widget.questionModel.correctOption) {
                    setState(() {
                      optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _attempted = _attempted + 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _attempted = _attempted - 1;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(136, 230, 226, 226),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: OptionTile(
                    option: "C",
                    description: "${widget.questionModel.option3}",
                    correctAnswer: widget.questionModel.correctOption,
                    optionSelected: optionSelected,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  ///correct
                  if (widget.questionModel.option4 ==
                      widget.questionModel.correctOption) {
                    setState(() {
                      optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _attempted = _attempted + 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _attempted = _attempted - 1;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(136, 230, 226, 226),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: OptionTile(
                    option: "D",
                    description: "${widget.questionModel.option4}",
                    correctAnswer: widget.questionModel.correctOption,
                    optionSelected: optionSelected,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
