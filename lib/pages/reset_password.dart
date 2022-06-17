import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class resetPassword extends StatelessWidget {
  resetPassword({Key key}) : super(key: key);
TextEditingController email=TextEditingController();

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body:Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Email Is Empty";
                    } else if (validateEmail(email) == false) {
                      return "Please Enter Valid email";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      labelStyle: TextStyle(fontSize: 15,color: Colors.black)),
                ),
                SizedBox(height: 15.0,),
                RaisedButton(
                  color: Colors.teal,
                  onPressed:() {
                    if (email.text.isNotEmpty) {
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email.text);
                      Fluttertoast.showToast(
                          msg: "Email Sent",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else{
                      Fluttertoast.showToast(
                          msg: "Email field must not be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  },
                  child: Text('Reset',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
               // SizedBox(height: 5.0,),
                RaisedButton(
                  color: Colors.grey[500],
                  onPressed:(){Navigator.pop(context);},
                  child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
            ],
                mainAxisSize: MainAxisSize.min,
        ),
          )

      ),
    ));
  }
}


