import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  NotificationHelper._();
  static final instance = NotificationHelper._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {}
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    const init = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(init);
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleDaily({
    required int id,
    required DateTime when,
    String title = 'Alarm',
    String body = 'It’s time!',
  }) async {
    final next = _nextDaily(DateTime.now(), when);
    const android = AndroidNotificationDetails(
      'alarms',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(next, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(next, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleOneShot({
    required int id,
    required DateTime at,
    String title = 'Alarm',
    String body = 'It’s time!',
  }) async {
    final fireAt = at.isAfter(DateTime.now())
        ? at
        : DateTime.now().add(const Duration(seconds: 5));
    const android = AndroidNotificationDetails(
      'alarms',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(fireAt, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(fireAt, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );
    }
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  DateTime _nextDaily(DateTime now, DateTime base) {
    final today = DateTime(
      now.year,
      now.month,
      now.day,
      base.hour,
      base.minute,
    );
    return today.isAfter(now) ? today : today.add(const Duration(days: 1));
  }
}
