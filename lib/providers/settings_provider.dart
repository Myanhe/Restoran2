import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_helper.dart';

class SettingsProvider extends ChangeNotifier {
  static const _reminderKey = 'dailyReminderEnabled';

  bool _dailyReminder = false;
  bool get dailyReminder => _dailyReminder;

  String? _scheduleError;
  String? get scheduleError => _scheduleError;

  final NotificationHelper _notificationHelper = NotificationHelper();

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyReminder = prefs.getBool(_reminderKey) ?? false;
    if (_dailyReminder) {
      // initNotifications() already called in main() — only re-schedule here
      try {
        await _notificationHelper.scheduleDailyAt11();
      } catch (e) {
        debugPrint('[NotificationHelper] Failed to reschedule on load: $e');
      }
    }
    notifyListeners();
  }

  Future<void> setDailyReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    _dailyReminder = enabled;
    _scheduleError = null;
    await prefs.setBool(_reminderKey, enabled);
    if (enabled) {
      try {
        await _notificationHelper.scheduleDailyAt11();
      } catch (e) {
        _scheduleError = e.toString();
        debugPrint('[NotificationHelper] Failed to schedule: $e');
      }
    } else {
      await _notificationHelper.cancelDaily();
    }
    notifyListeners();
  }
}
