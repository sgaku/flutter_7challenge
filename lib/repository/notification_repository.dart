import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';

class NotificationRepository {
  Future<void> zonedScheduleNotification() async {
    ///定時の設定
    var notifyTime = "7:00 AM";
    final format = DateFormat.jm();
    final pref = await SharedPreferences.getInstance();
    TimeOfDay schedule = TimeOfDay.fromDateTime(format.parse(notifyTime));
    tz.TZDateTime nextInstanceOfTime() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
          now.day, schedule.hour, schedule.minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '7時チャレンジ',
        pref.getString('notification') ?? '7時だよ！誰よりも早く記録しにいこう！',
        nextInstanceOfTime(),
        const NotificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
