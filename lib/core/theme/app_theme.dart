import 'package:flutter/material.dart';
import 'app_colors.dart';

enum ColorPalette { cobalt, emerald, amethyst }
enum ThemeModeType { system, light, dark }

class AppThemeState {
  final ColorPalette palette;
  final ThemeModeType mode;

  const AppThemeState({
    this.palette = ColorPalette.cobalt,
    this.mode = ThemeModeType.system,
  });

  AppThemeState copyWith({ColorPalette? palette, ThemeModeType? mode}) {
    return AppThemeState(
      palette: palette ?? this.palette,
      mode: mode ?? this.mode,
    );
  }
}

class AppTheme {
  static ThemeData getTheme({
    required ColorPalette palette,
    required bool isDark,
  }) {
    Color primaryLight;
    Color primaryContainerLight;
    Color primaryDark;
    Color primaryContainerDark;

    switch (palette) {
      case ColorPalette.cobalt:
        primaryLight = AppColors.cobaltPrimaryLight;
        primaryContainerLight = AppColors.cobaltPrimaryContainerLight;
        primaryDark = AppColors.cobaltPrimaryDark;
        primaryContainerDark = AppColors.cobaltPrimaryContainerDark;
        break;
      case ColorPalette.emerald:
        primaryLight = AppColors.emeraldPrimaryLight;
        primaryContainerLight = AppColors.emeraldPrimaryContainerLight;
        primaryDark = AppColors.emeraldPrimaryDark;
        primaryContainerDark = AppColors.emeraldPrimaryContainerDark;
        break;
      case ColorPalette.amethyst:
        primaryLight = AppColors.amethystPrimaryLight;
        primaryContainerLight = AppColors.amethystPrimaryContainerLight;
        primaryDark = AppColors.amethystPrimaryDark;
        primaryContainerDark = AppColors.amethystPrimaryContainerDark;
        break;
    }

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primaryDark,
            primaryContainer: primaryContainerDark,
            surface: AppColors.surfaceDark,
            surfaceContainerHighest: AppColors.surfaceVariantDark,
            onSurface: AppColors.onSurfaceDark,
            onSurfaceVariant: AppColors.onSurfaceVariantDark,
          )
        : ColorScheme.light(
            primary: primaryLight,
            primaryContainer: primaryContainerLight,
            surface: AppColors.surfaceLight,
            surfaceContainerHighest: AppColors.surfaceVariantLight,
            onSurface: AppColors.onSurfaceLight,
            onSurfaceVariant: AppColors.onSurfaceVariantLight,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedCornerShape(16),
      ),
    );
  }
}

ShapeBorder RoundedCornerShape(double radius) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
