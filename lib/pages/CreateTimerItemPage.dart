import 'package:flutter/services.dart';
import 'package:flutter_timer/controller/timerList.dart';
import 'package:flutter_timer/model/timerItem.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateTimerItemPage extends StatefulWidget {
  @override
  createState() => CreateTimerItemPageState();
}

class CreateTimerItemPageState extends State<CreateTimerItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TimerListController timerList = Get.find();

  String name = '';
  int time = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new timer"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "이름"),
                onSaved: (v) {
                  name = v ?? '';
                },
                validator: (v) {
                  if (v == null || v.length == 0) return "이름을 입력하시오";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "시간 (초)"),
                keyboardType: TextInputType.number,
                onSaved: (v) {
                  time = int.parse(v ?? '0');
                },
                validator: (v) {
                  if (v == null || v.length == 0) return "시간을 입력해주시오";
                  return null;
                },
              ),
              Row(
                children: [
                  TextButton(
                    child: Text(
                      "저장",
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        timerList.addItem(TimerItem(name: name, time: time));
                        Get.back();
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      "취소",
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
