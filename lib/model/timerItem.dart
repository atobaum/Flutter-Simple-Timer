import 'dart:convert';

class TimerItem {
  String name;
  int time;

  TimerItem({required this.name, required this.time});

  String toJson() {
    return jsonEncode({"name": name, "time": time});
  }

  TimerItem.fromMap(Map<String, dynamic> json)
      : name = json['name'],
        time = json['time'];
}
