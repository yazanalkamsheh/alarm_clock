// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_clock_quiz/modules/login/login_screen.dart';
import 'package:flutter_clock_quiz/modules/register/register_screen.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';

class ToProfileScreen extends StatelessWidget {
  const ToProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget buildSignUpButton() {
      return defaultButton(
        function: () {
          navigateTo(context, RegisterScreen());
        },
        text: 'sign up',
      );
    }
    Widget buildLoginButton() {
      return defaultButton(
        function: () {
          navigateTo(context, LoginScreen());
        },
        text: 'login',
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'assets/login.png',
              ),
            ),
            buildSignUpButton(),
            SizedBox(
              height: 14.0,
            ),
            buildLoginButton(),
          ],
        ),
      ),
    );
  }
}
