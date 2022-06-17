// ignore_for_file: missing_return

import 'package:Vikalp/widgets/time_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProgressBar extends StatefulWidget {
  const ProgressBar({Key key}) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        child: GetBuilder<TimeController>(
            init: TimeController(),
            builder: (controller) {
              if ((controller.totalDuration != null)) {
                Duration clockTimer =
                    Duration(seconds: controller.animation.value);
                String timerText =
                    '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
                return Row(
                  children: [
                    Icon(Icons.alarm_rounded, color: Colors.white),
                    RichText(
                        text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '  $timerText  ',
                            style: TextStyle(
                              fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        TextSpan(
                            text: 'Left',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white)),
                      ],
                    ))
                    // Text(
                    // ':  $timerText',
                    // style: TextStyle(color: Colors.white),
                    // ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    ));
  }
}
