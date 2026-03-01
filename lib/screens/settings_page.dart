import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/notification_helper.dart';

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
          // ⚠️ TEST BRANCH ONLY — remove before merging to main
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              '⚠️ Test Tools (hapus sebelum submit)',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.orange),
            title: const Text('Test Notifikasi Langsung'),
            subtitle: const Text('Munculkan notifikasi sekarang juga'),
            onTap: () async {
              final helper = NotificationHelper();
              await helper.showTestNotificationNow();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🔔 Notifikasi dikirim! Cek notification bar.'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.orange),
            title: const Text('Test Scheduled (10 detik)'),
            subtitle: const Text('Notifikasi muncul 10 detik lagi'),
            onTap: () async {
              final helper = NotificationHelper();
              await helper.scheduleDailyAt11();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⏰ Notifikasi dijadwalkan 10 detik lagi!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
