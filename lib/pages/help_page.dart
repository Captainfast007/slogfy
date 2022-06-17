import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:share/share.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Screens/SettingScreen.dart';
import '../Services/jitsiMeetService.dart';
import '../Services/services.dart';

class HelpSection extends StatefulWidget {
  const HelpSection({Key key}) : super(key: key);

  @override
  State<HelpSection> createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection>
    with TickerProviderStateMixin {
  TabController _tabController;
  TextEditingController meeting = TextEditingController();
  TextEditingController joinmeeting = TextEditingController();
  TextEditingController subject = TextEditingController();
  bool enableAudio = true;
  bool enableVideo = true;
  bool isLoading = false;
  String meetingCode;
  final _formKey = GlobalKey<FormState>();
  JitsiMeets meets = JitsiMeets();
  String name, email;

  int option = 0;
  int bottom = 1;

  FirebaseServices services = FirebaseServices();

  @override
  void initState() {
    _tabController = TabController(initialIndex: 1, length: 4, vsync: this);
    rendomText();
    super.initState();
    getUserData();
  }

  getUserData() async {
    final databaseReference =FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    databaseReference.then((data) {
      name = data["name"];
      email = data["email"];

    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  shareMeetingCode() {
    Share.share(
        "Hey Buddy! Use This Code to Do meeting with me on Vikalp Download App and in Join Meeting Use Code $meetingCode");
  }

  rendomText() {
    meetingCode = randomAlphaNumeric(10);
    meeting.text = meetingCode;
  }

  returnScreeen() {
    switch (option) {
      case 0:
        return createMeeting();
        break;
      case 1:
        return joinMeeting();
        break;
      default:
        return SettingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffff2d55),
          centerTitle: true,
          title: Text(
            "Help Section",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: TabBar(
                  onTap: (value) => {
                    setState(() {
                      option = value;
                      print(option);
                    })
                  },
                  tabs: [
                    Tab(
                      text: "Give Help",
                    ),
                    Tab(
                      text: "Get Help",
                    ),
                  ],
                  labelColor: Colors.black,
                  indicator: RectangularIndicator(
                    color: Color.fromARGB(255, 38, 23, 90),
                    bottomLeftRadius: 80,
                    bottomRightRadius: 80,
                    topLeftRadius: 80,
                    topRightRadius: 80,
                    paintingStyle: PaintingStyle.stroke,
                  ),
                ),
              ),
            ),
            returnScreeen()
          ],
        ),
      ),
    );
  }

  Widget createMeeting() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black, // shadow direction: bottom right
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
                  child: Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: subject,
                      validator: (meetings) {
                        if (meetings == null || meetings.isEmpty) {
                          return "Meeting Subject Is Empty";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Meeting Subject',
                          prefixIcon: Icon(Icons.subject),
                          labelStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: meeting,
                      validator: (meetings) {
                        if (meetings == null || meetings.isEmpty) {
                          return "Meeting Name Is Empty";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Meeting Name',
                        prefixIcon: Icon(Icons.videocam),
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Mute Audio"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlutterSwitch(
                                width: 60.0,
                                height: 30.0,
                                valueFontSize: 12.0,
                                toggleSize: 20.0,
                                value: enableAudio,
                                activeColor: Color.fromARGB(255, 38, 23, 90),
                                inactiveColor: Colors.grey,
                                inactiveToggleColor: Colors.black,
                                inactiveTextColor: Colors.white,
                                activeText: "",
                                inactiveText: "",
                                activeTextColor: Colors.black,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    enableAudio = val;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Mute Video"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlutterSwitch(
                                width: 60.0,
                                height: 30.0,
                                valueFontSize: 12.0,
                                toggleSize: 20.0,
                                value: enableVideo,
                                activeColor: Color.fromARGB(255, 38, 23, 90),
                                inactiveColor: Colors.grey,
                                inactiveToggleColor: Colors.black,
                                inactiveTextColor: Colors.white,
                                activeText: "",
                                inactiveText: "",
                                activeTextColor: Colors.black,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    enableVideo = val;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          services.addMeetingInFirebase(
                            subject.text,
                            meetingCode,
                            email,
                          );
                          meets.joinMeeting(meetingCode, name, email,
                              subject.text, enableAudio, enableVideo);
                        }
                      },
                      child: isLoading != true
                          ? Text(
                              'Create Meeting'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                      color: Color.fromARGB(255, 38, 23, 90),
                      elevation: 0,
                      minWidth: 250,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(shareMeetingCode());
                        },
                        child: Container(
                            width: 100,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 38, 23, 90),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Share",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.share, color: Colors.white),
                              ],
                            )
                            // child: IconButton(
                            //   onPressed: () {
                            //     shareMeetingCode();
                            //   },
                            //   icon: Icon(Icons.share, color: Colors.white),
                            // ),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget joinMeeting() {
    {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black, // shadow direction: bottom right
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Container(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: joinmeeting,
                        validator: (meetings) {
                          if (meetings == null || meetings.isEmpty) {
                            return "Meeting Name Is Empty";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Meeting Name',
                            prefixIcon: Icon(Icons.videocam),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Mute Audio"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: FlutterSwitch(
                                  width: 60.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: enableAudio,
                                  activeColor: Color.fromARGB(255, 38, 23, 90),
                                  inactiveColor: Colors.grey,
                                  inactiveToggleColor: Colors.black,
                                  inactiveTextColor: Colors.white,
                                  activeText: "",
                                  inactiveText: "",
                                  activeTextColor: Colors.black,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      enableAudio = val;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Mute Video"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: FlutterSwitch(
                                  width: 60.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: enableVideo,
                                  activeColor: Color.fromARGB(255, 38, 23, 90),
                                  inactiveColor: Colors.grey,
                                  inactiveToggleColor: Colors.black,
                                  inactiveTextColor: Colors.white,
                                  activeText: "",
                                  inactiveText: "",
                                  activeTextColor: Colors.black,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      enableVideo = val;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          meets.joinMeeting(joinmeeting.text, name, email,
                              subject.text, enableAudio, enableVideo);
                        }
                      },
                      child: isLoading != true
                          ? Text(
                              'Join Meeting'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                      color: Color.fromARGB(255, 38, 23, 90),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);

  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
