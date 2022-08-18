// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_quiz/layout/cubit/cubit.dart';
import 'package:flutter_clock_quiz/modules/alarm/clock_screen/clock_screen.dart';
import 'package:flutter_clock_quiz/shared/components/components.dart';
import 'package:intl/intl.dart';

import '../../layout/cubit/state.dart';

class AlarmScreen extends StatefulWidget {
  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var sleepTimeController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var numOfDay;
  var dateName;
  var hourOfDayWake;
  var minuteOfDayWake;
  var hourOfDaySleep;
  var minuteOfDaySleep;


  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Allow Notifications'),
                  content: Text('Our app would like to send you notifications'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Don\'t Allow',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((_) => Navigator.pop(context)),
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlutterClockCubit, FlutterClockStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FlutterClockCubit cubit = FlutterClockCubit.get(context);

        Widget buildDate() {
          return defaultFormField(
            controller: dateController,
            type: TextInputType.datetime,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.parse('2022-09-18'),
              ).then((value) {
                dateController.text = DateFormat.yMMMd().format(value!);
                DateTime nameDayOfWeek = DateTime(
                    value.year, value.month, value.day);
                dateName = DateFormat('E').format(nameDayOfWeek);
                numOfDay = nameDayOfWeek.day;
                print(value.toString());
              });
            },
            validate: (value) {
              if (value!.isEmpty) {
                return 'date must not be empty';
              }
              return null;
            },
            label: 'Alarm Date',
            prefix: Icons.calendar_today,
          );
        }
        Widget buildTime() {
          return defaultFormField(
            controller: timeController,
            type: TextInputType.datetime,
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                timeController.text = value!.format(context).toString();
                hourOfDayWake = value.hour;
                minuteOfDayWake = value.minute;
                print(hourOfDayWake);
              });
            },
            validate: (value) {
              if (value!.isEmpty) {
                return 'time must not be empty';
              }
              return null;
            },
            label: 'Alarm Time',
            prefix: Icons.watch_later_outlined,
          );
        }
        Widget buildTimeOfSleep() {
          return defaultFormField(
            controller: sleepTimeController,
            type: TextInputType.datetime,
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                sleepTimeController.text = value!.format(context).toString();
                hourOfDaySleep = value.hour;
                minuteOfDaySleep = value.minute;
              });
            },
            validate: (value) {
              if (value!.isEmpty) {
                return 'time must not be empty';
              }
              return null;
            },
            label: 'Sleep Time',
            prefix: Icons.bedtime,
          );
        }


        var alarms = cubit.newAlarms;

        return Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClockView(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        if (!cubit.isBottomSheetShown) {
                          cubit.isBottomSheetShown = true;
                          scaffoldKey.currentState!
                              .showBottomSheet(
                                (context) =>
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(
                                    20.0,
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            FloatingActionButton(
                                              backgroundColor:
                                              Color(0xFF2D2F41),
                                              child: Icon(Icons.check),
                                              onPressed: () async {
                                                if (cubit.isBottomSheetShown) {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    int hoursOfSleep;
                                                    int minuteOfSleep;

                                                    if (hourOfDayWake >=
                                                        hourOfDaySleep &&
                                                        minuteOfDayWake >=
                                                            minuteOfDaySleep) {
                                                      hoursOfSleep =
                                                          hourOfDayWake -
                                                              hourOfDaySleep;
                                                      minuteOfSleep =
                                                          minuteOfDayWake -
                                                              minuteOfDaySleep;
                                                    }
                                                    else if (hourOfDayWake >
                                                        hourOfDaySleep &&
                                                        minuteOfDayWake <
                                                            minuteOfDaySleep) {
                                                      hoursOfSleep =
                                                          (hourOfDayWake -
                                                              hourOfDaySleep) -
                                                              1;
                                                      minuteOfSleep = 60 -
                                                          (minuteOfDaySleep -
                                                              minuteOfDayWake) as int;
                                                    } else {
                                                      hoursOfSleep = 0;
                                                      minuteOfSleep = 0;
                                                    }


                                                    //late DateTime numDayOfWeek;
                                                    // numDayOfWeek = DateTime(now.year, now.month, now.day);
                                                    // cubit.dayOfTheWeek = numDayOfWeek;
                                                    //  cubit.hourTimeOfDay = hourOfDayWake;
                                                    //  cubit.minuteTimeOfDay = minuteOfDayWake;
                                                    //  cubit.dayOfTheWeek = numOfDay;

                                                    cubit.insertToDatabase(
                                                      time: timeController.text,
                                                      date: dateController.text,
                                                      hoursOfSleep: hoursOfSleep,
                                                      minuteOfSleep: minuteOfSleep,
                                                      nameDayOfWeek: dateName,
                                                    );

                                                    //cubit.createWaterReminderNotification();

                                                  }
                                                }
                                                Navigator.pop(context);
                                                cubit.isBottomSheetShown =
                                                false;
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        buildTime(),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        buildTimeOfSleep(),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        buildDate(),
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20.0,
                          )
                              .closed
                              .then((value) {
                            cubit.isBottomSheetShown = false;
                            print("close");
                          }).onError((error, stackTrace) {
                            print('this is error $error');
                          });
                        }
                      },
                    ),
                  ],
                ),
                alarmsBuilder(alarms: alarms,context: context),
              ],
            ),
          ),
        );
      },
    );
  }
}


