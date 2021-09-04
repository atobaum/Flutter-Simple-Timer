String formatTime(int time) {
  final min = (time / 60).floor();
  final sec = time % 60;

  String res = "$sec초";

  if (min > 0) {
    res = "$min분 " + res;
  }

  return res;
}
