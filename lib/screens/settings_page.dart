import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/notification_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Request POST_NOTIFICATIONS permission as soon as Settings page is visible.
    // This is the correct time: MainActivity is active so the system dialog appears.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationHelper().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: theme.isDarkMode,
            onChanged: theme.setDarkMode,
          ),
          SwitchListTile(
            title: const Text('Daily Reminder (11:00 AM)'),
            value: settings.dailyReminder,
            onChanged: settings.setDailyReminder,
          ),
        ],
      ),
    );
  }
}
