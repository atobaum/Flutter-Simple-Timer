import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter_timer/controller/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer/widgets/Counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TimerController());

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Animation<double> ani;

  TimerController c = Get.find();

  @override
  void initState() {
    super.initState();
    ani = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  startTimer(int sec) {
    c.setTimer(sec);
    setState(() {
      ani = AnimationController(vsync: this, duration: Duration(seconds: sec))
        ..forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // CountDownTimer(),
            AnimatedBuilder(
                animation: ani,
                builder: (context, child) {
                  return Center(
                      child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Stack(
                            children: [
                              Center(
                                child: Counter(),
                              ),
                              SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: CustomPaint(
                                    painter: CountdownRing(
                                        animation: ani,
                                        backgroundColor: Colors.white,
                                        color: Colors.red),
                                  ))
                            ],
                          )));
                }),
            TimerList(onClick: (item) {
              startTimer(item.time);
            })
          ],
        ),
      ),
    );
  }
}

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

String formatTime(int second) {
  int min = (second / 60).floor();
  int sec = second % 60;
  if (min > 0) return "$min분 $sec초";

  return "$sec초";
}

class TimerList extends StatefulWidget {
  TimerList({required this.onClick});
  final void Function(TimerItem) onClick;

  @override
  createState() => TimerListState(onClick: onClick);
}

class TimerListState extends State<TimerList> {
  final prefKey = "timers";

  List<TimerItem> items = [];
  final void Function(TimerItem) onClick;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var a = prefs.getStringList(prefKey);
      // prefs.remove(prefKey);
      print("saved items $a");

      if (a == null) {
        setState(() {
          items = [
            TimerItem(name: "기본", time: 5),
            TimerItem(name: "홍차", time: 60 * 2 + 30),
            TimerItem(name: "파스타", time: 60 * 9),
          ];

          prefs.setStringList(
              prefKey, items.map((item) => item.toJson()).toList());
        });
      } else {
        setState(() {
          items = a
              .map((s) => jsonDecode(s))
              .map((json) => TimerItem.fromMap(json))
              .toList();
        });
      }
    });
  }

  TimerListState({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              var item = items[index];
              return TextButton(
                  onPressed: () => onClick(item),
                  child: Row(
                    children: [Text(item.name), Text(formatTime(item.time))],
                  ));
            }),
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              items.add(TimerItem(name: "new", time: 3));
            });
            prefs.setStringList(prefKey, items.map((e) => e.toJson()).toList());
          },
          child: Text("add"),
        ),
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove(prefKey);
          },
          child: Text("remve all"),
        )
      ],
    );
  }
}

class CountdownRing extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  CountdownRing(
      {required this.animation,
      required this.backgroundColor,
      required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    paint.color = color;
    double progress = animation.value * 2.0 * pi;
    canvas.drawArc(Offset.zero & size, -pi * 0.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(CountdownRing old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
