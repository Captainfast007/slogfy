import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(
              text: 'Vikalp',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          TextSpan(
              text: 'Quiz',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }
}
