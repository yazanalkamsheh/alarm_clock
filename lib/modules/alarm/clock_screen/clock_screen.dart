// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_clock_quiz/modules/alarm/clock_screen/analogic_circle.dart';
import 'package:flutter_clock_quiz/modules/alarm/clock_screen/hour_pointer.dart';
import 'package:flutter_clock_quiz/modules/alarm/clock_screen/minute_pointer.dart';
import 'package:flutter_clock_quiz/modules/alarm/clock_screen/second_pointer.dart';
import 'package:intl/intl.dart';


class ClockView extends StatelessWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        Duration(seconds: 1),
      ),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnalogicCircle(),
                  SecondPointer(),
                  MinutePointer(),
                  HourPointer(),
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Column(
                children: [
                  Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Color(0xFF2D2F41)),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
