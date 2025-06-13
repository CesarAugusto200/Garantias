import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate, BuildContext context) async {
    try {
      if (scheduledDate == null) {
        print("Error: La fecha de vencimiento es nula.");
        return;
      }

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime == null) {
        return;
      }

      DateTime finalDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      tz.TZDateTime scheduledNotification =
      tz.TZDateTime.from(finalDateTime, tz.local);

      final androidDetails = AndroidNotificationDetails(
        'warranty_channel',
        'Garantías',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      final details = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledNotification,
        details,
        androidScheduleMode: AndroidScheduleMode.exact,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print("Notificación programada para: $scheduledNotification");
    } catch (e) {
      print("Error al programar la notificación: $e");
    }
  }
}
