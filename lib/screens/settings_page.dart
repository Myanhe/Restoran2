import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
