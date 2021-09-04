import 'dart:convert';

import 'package:flutter_timer/model/timerItem.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefKey = "timers";

final sampleList = [
  TimerItem(name: "기본", time: 5),
  TimerItem(name: "홍차", time: 60 * 2 + 30),
  TimerItem(name: "파스타", time: 60 * 9),
];

class TimerListController extends GetxController {
  var items = <TimerItem>[].obs;

  TimerListController() {
    _init();
  }

  _init() async {
    var prefs = await SharedPreferences.getInstance();
    var savedItems = prefs.getStringList(prefKey);
    if (savedItems == null) {
      items.value = sampleList;
      _updateSharedPreferences();
    } else {
      items.value = savedItems
          .map(jsonDecode)
          .map((json) => TimerItem.fromMap(json))
          .toList();
    }
  }

  addItem(TimerItem v) {
    items.add(v);
    _updateSharedPreferences();
  }

  removeItem(TimerItem v) {
    int i = items.indexOf(v);
    if (i >= 0) {
      items.removeAt(i);
      _updateSharedPreferences();
    }
  }

  changeOrder(int prev, int next) {
    final v = items.removeAt(prev);
    items.insert(prev < next ? next - 1 : next, v);

    _updateSharedPreferences();
  }

  _updateSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefKey, items.map((item) => item.toJson()).toList());
  }
}
