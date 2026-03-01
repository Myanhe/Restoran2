import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_helper.dart';

class SettingsProvider extends ChangeNotifier {
  static const _reminderKey = 'dailyReminderEnabled';

  bool _dailyReminder = false;
  bool get dailyReminder => _dailyReminder;

  final NotificationHelper _notificationHelper = NotificationHelper();

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyReminder = prefs.getBool(_reminderKey) ?? false;
    if (_dailyReminder) {
      await _notificationHelper.initNotifications();
      await _notificationHelper.scheduleDailyAt11();
    }
    notifyListeners();
  }

  Future<void> setDailyReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    _dailyReminder = enabled;
    await prefs.setBool(_reminderKey, enabled);
    if (enabled) {
      await _notificationHelper.initNotifications();
      await _notificationHelper.scheduleDailyAt11();
    } else {
      await _notificationHelper.cancelDaily();
    }
    notifyListeners();
  }
}
