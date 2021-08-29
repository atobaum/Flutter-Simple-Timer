import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  var remainingTime = 0.obs;
  var isRunning = false.obs;
  late Timer _timer;

  startTimer() {
    isRunning.value = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      remainingTime--;
      if (remainingTime.value == 0) {
        _timer.cancel();
        isRunning.value = false;
        var cache = AudioCache();
        cache.play("medium_bell_ringing_Near.mp3");
      }
    });
  }

  pauseTimer() {
    if (isRunning.value) {
      _timer.cancel();
    }
  }

  setTimer(int seconds) {
    pauseTimer();
    remainingTime.value = seconds;
    startTimer();
  }
}
