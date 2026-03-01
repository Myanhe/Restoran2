import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    tzdata.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduleDailyAt11() async {
    final time = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, time.year, time.month, time.day, 11, 0);
    if (scheduled.isBefore(time)) scheduled = scheduled.add(const Duration(days: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Lunch Reminder',
      'Waktunya makan siang! Cek rekomendasi restoran.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', 'Daily Reminder', importance: Importance.defaultImportance),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDaily() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
