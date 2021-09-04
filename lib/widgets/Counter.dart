import 'package:flutter/material.dart';
import 'package:flutter_timer/controller/timer.dart';
import 'package:flutter_timer/lib/formatTime.dart';
import 'package:get/get.dart';

class Counter extends StatelessWidget {
  final TimerController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(formatTime(c.remainingTime.value),
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)));
  }
}
