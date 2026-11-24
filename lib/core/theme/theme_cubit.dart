import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'app_theme.dart';

class ThemeCubit extends Cubit<AppThemeState> {
  static const String boxName = 'theme_box';
  static const String keyPalette = 'selected_palette';
  static const String keyMode = 'selected_mode';

  ThemeCubit() : super(const AppThemeState()) {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    try {
      final box = Hive.box(boxName);
      final paletteIndex = box.get(keyPalette, defaultValue: 0) as int;
      final modeIndex = box.get(keyMode, defaultValue: 0) as int;

      emit(AppThemeState(
        palette: ColorPalette.values[paletteIndex.clamp(0, ColorPalette.values.length - 1)],
        mode: ThemeModeType.values[modeIndex.clamp(0, ThemeModeType.values.length - 1)],
      ));
    } catch (_) {}
  }

  void updatePalette(ColorPalette palette) {
    emit(state.copyWith(palette: palette));
    try {
      Hive.box(boxName).put(keyPalette, palette.index);
    } catch (_) {}
  }

  void updateMode(ThemeModeType mode) {
    emit(state.copyWith(mode: mode));
    try {
      Hive.box(boxName).put(keyMode, mode.index);
    } catch (_) {}
  }
}
