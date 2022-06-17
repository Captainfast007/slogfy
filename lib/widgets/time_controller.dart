// ignore_for_file: deprecated_member_use

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/home.dart';


class TimeController extends GetxController with SingleGetTickerProviderMixin {
  // AnimationController _controller;
  var _totalDuration;
  set setTime(int duration) {
    _totalDuration = duration;
    setDuration();
  }

  AnimationController _animationController;
  Animation _animation;
  Animation get animation => this._animation;
  get totalDuration => _totalDuration;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  setDuration() {
    Future.delayed(Duration(seconds: _totalDuration), () {
      Get.to(Home());
    });
    _animationController = AnimationController(
        duration: Duration(seconds: _totalDuration
            //  totalDuration
            ),
        vsync: this);
    _animation =
        StepTween(begin: _totalDuration, end: 0).animate(_animationController)
          ..addListener(() {
            // update like setState
            update();
          });
    _animationController.forward();
    super.onInit();
  }
}
