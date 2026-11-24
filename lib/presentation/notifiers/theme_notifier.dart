import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/theme/app_theme.dart';

class ThemeNotifier extends StateNotifier<AppThemeState> {
  static const String boxName = 'theme_box';
  static const String keyPalette = 'selected_palette';
  static const String keyMode = 'selected_mode';

  ThemeNotifier() : super(const AppThemeState()) {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    try {
      final box = Hive.box(boxName);
      final paletteIndex = box.get(keyPalette, defaultValue: 0) as int;
      final modeIndex = box.get(keyMode, defaultValue: 0) as int;

      state = AppThemeState(
        palette: ColorPalette.values[paletteIndex.clamp(0, ColorPalette.values.length - 1)],
        mode: ThemeModeType.values[modeIndex.clamp(0, ThemeModeType.values.length - 1)],
      );
    } catch (_) {}
  }

  void updatePalette(ColorPalette palette) {
    state = state.copyWith(palette: palette);
    try {
      Hive.box(boxName).put(keyPalette, palette.index);
    } catch (_) {}
  }

  void updateMode(ThemeModeType mode) {
    state = state.copyWith(mode: mode);
    try {
      Hive.box(boxName).put(keyMode, mode.index);
    } catch (_) {}
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeState>((ref) {
  return ThemeNotifier();
});
