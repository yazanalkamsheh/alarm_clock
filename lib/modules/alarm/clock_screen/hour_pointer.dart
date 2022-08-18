// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourPointer extends StatelessWidget {
  const HourPointer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final hour = double.parse((DateFormat('hh').format(DateTime.now())));
    final angle = (-pi * (hour / -11.5)) * 2;
    final width = MediaQuery.of(context).size.width;
    bool isPortait = height > width;
    return RotatedBox(
      quarterTurns: 2,
      child: Transform.rotate(
        angle: angle,
        child: Transform.translate(
          offset: Offset(0, 20),
          child: Center(
            child: Container(
              height: isPortait ? height * 0.03 : width * 0.03,
              width: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}