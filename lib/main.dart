// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_null_comparison, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_quiz/layout/flutter_clock.dart';
import 'package:flutter_clock_quiz/modules/to_profile/to_profile_screen.dart';
import 'package:flutter_clock_quiz/shared/bloc_observer.dart';
import 'package:flutter_clock_quiz/shared/components/constant.dart';
import 'package:flutter_clock_quiz/shared/network/local/cache_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();


  AwesomeNotifications().initialize(
    'resource://drawable/alarm.png',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        channelDescription: 'Alarm',
        locked: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/alarm',
      ),
    ],
  );
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');
  print(uId);
  if(uId != null )
  {
    widget = FlutterClockLayout();
  } else
  {
    widget = ToProfileScreen();
  }
  BlocOverrides.runZoned(
        () {
      // Use cubits...
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
  
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;

   MyApp({
    this.startWidget,
  });


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startWidget,
    );
  }
}
