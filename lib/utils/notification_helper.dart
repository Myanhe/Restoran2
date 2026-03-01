import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;

  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings,
        );

    tzdata.initializeTimeZones();

    // Set local timezone to Asia/Jakarta (WIB - Western Indonesia Time)
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // Request POST_NOTIFICATIONS permission at runtime (required for Android 13 / API 33+)
    if (!kIsWeb) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  // ⚠️  TEST BRANCH: fires 10 seconds after toggle instead of waiting for 11 AM
  Future<void> scheduleDailyAt11() async {
    try {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      // TODO(test): replace with real 11 AM schedule before merging to main
      final tz.TZDateTime scheduledDate = now.add(const Duration(seconds: 10));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Lunch Reminder',
        'Waktunya makan siang! Cek rekomendasi restoran.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Reminder',
            channelDescription: 'Daily lunch reminder at 11 AM',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Error handling silently - notification scheduling issue
      // Errors can occur due to timezone or platform-specific issues
    }
  }

  // TEST HELPER: shows an immediate notification to verify the channel works
  Future<void> showTestNotificationNow() async {
    await flutterLocalNotificationsPlugin.show(
      99,
      '🔔 Test Notifikasi',
      'Notifikasi berhasil tampil! Fitur reminder berjalan normal.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          channelDescription: 'Daily lunch reminder at 11 AM',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelDaily() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(0);
    } catch (e) {
      // Error handling silently - notification cancellation issue
    }
  }
}
