import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/favorite_page.dart';
import 'theme/app_theme.dart';
import 'utils/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final favoriteProvider = FavoriteProvider();
  await favoriteProvider.loadFavorites();

  await NotificationHelper().initNotifications();

  runApp(
    MyApp(
      themeProvider: themeProvider,
      settingsProvider: settingsProvider,
      favoriteProvider: favoriteProvider,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final SettingsProvider settingsProvider;
  final FavoriteProvider favoriteProvider;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.settingsProvider,
    required this.favoriteProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => settingsProvider,
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => favoriteProvider,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routes: {
              '/settings': (_) => const SettingsPage(),
              '/favorites': (_) => const FavoritePage(),
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
