import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime
      .now()
      .microsecondsSinceEpoch
      .remainder(100000);
}


class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}


Future<NotificationWeekAndTime?> pickSchedule(BuildContext context) async {
  List<String> weekDays = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wen',
    'Thu',
    'Fri',
  ];

  TimeOfDay timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

  await showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text(
        'Hey wake up',
        textAlign: TextAlign.center,
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3,
        children: [
          for(int index = 0; index < weekDays.length; index++)
            ElevatedButton(onPressed: () {
              selectedDay = index + 1;
              Navigator.pop(context);
            },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
              child: Text(weekDays[index]),),
        ],
      ),
    );
  });
}


Future<void> createReminderNotification(
    NotificationWeekAndTime notificationWeekAndTime
    ) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      )
    ],
    schedule: NotificationCalendar(
      weekday: notificationWeekAndTime.dayOfTheWeek,
      hour: notificationWeekAndTime.timeOfDay.hour,
      minute: notificationWeekAndTime.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}
Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();}
