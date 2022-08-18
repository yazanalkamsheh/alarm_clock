// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AnalogicCircle extends StatelessWidget {
  const AnalogicCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isPortait = height > width;
    return Container(
      height: isPortait ? height * 0.24 : height * 0.34,
      width: width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF555769),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D2F41),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}