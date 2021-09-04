import 'dart:math';

import 'package:flutter_timer/controller/timerList.dart';
import 'package:flutter_timer/lib/formatTime.dart';
import 'package:flutter_timer/model/timerItem.dart';
import 'package:flutter_timer/pages/CreateTimerItemPage.dart';
import 'package:get/get.dart';
import 'package:flutter_timer/controller/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer/widgets/Counter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TimerController());
    Get.put(TimerListController());

    return GetMaterialApp(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(CreateTimerItemPage());
        },
      ),
    );
  }
}

class TimerList extends StatelessWidget {
  final void Function(TimerItem) onClick;
  final TimerListController timerList = Get.find();

  TimerList({required this.onClick});

  @override
  Widget build(BuildContext context) {
    var items = timerList.items;
    return Column(
      children: [
        Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              var item = items[index];
              return TextButton(
                  onPressed: () => onClick(item),
                  child: Row(
                    children: [
                      Text(item.name),
                      Text(formatTime(item.time)),
                      TextButton(
                          onPressed: () async {
                            timerList.removeItem(item);
                          },
                          child: Text("X"))
                    ],
                  ));
            })),
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
