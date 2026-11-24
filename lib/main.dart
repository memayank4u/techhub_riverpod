import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_strings.dart';
import 'core/database/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/notifiers/theme_notifier.dart';
import 'presentation/pages/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive Offline-first storage
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: TechHubRiverpodApp(),
    ),
  );
}

class TechHubRiverpodApp extends ConsumerWidget {
  const TechHubRiverpodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        palette: themeState.palette,
        isDark: false,
      ),
      darkTheme: AppTheme.getTheme(
        palette: themeState.palette,
        isDark: true,
      ),
      themeMode: themeState.mode == ThemeModeType.system
          ? ThemeMode.system
          : (themeState.mode == ThemeModeType.dark
              ? ThemeMode.dark
              : ThemeMode.light),
      home: const MainNavigationPage(),
    );
  }
}
