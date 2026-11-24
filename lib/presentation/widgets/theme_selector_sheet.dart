import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_theme.dart';
import '../notifiers/theme_notifier.dart';

class ThemeSelectorSheet extends ConsumerWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.themeDialogTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),

            // Palette Section
            Text(
              AppStrings.themePaletteLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),

            Row(
              children: [
                _buildPaletteOption(
                  context: context,
                  title: AppStrings.themePaletteCobalt,
                  color: AppColors.cobaltPrimaryLight,
                  isSelected: themeState.palette == ColorPalette.cobalt,
                  onTap: () => themeNotifier.updatePalette(ColorPalette.cobalt),
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
                _buildPaletteOption(
                  context: context,
                  title: AppStrings.themePaletteEmerald,
                  color: AppColors.emeraldPrimaryLight,
                  isSelected: themeState.palette == ColorPalette.emerald,
                  onTap: () => themeNotifier.updatePalette(ColorPalette.emerald),
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
                _buildPaletteOption(
                  context: context,
                  title: AppStrings.themePaletteAmethyst,
                  color: AppColors.amethystPrimaryLight,
                  isSelected: themeState.palette == ColorPalette.amethyst,
                  onTap: () => themeNotifier.updatePalette(ColorPalette.amethyst),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingLarge),

            // Mode Section
            Text(
              AppStrings.themeModeLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),

            SegmentedButton<ThemeModeType>(
              segments: const [
                ButtonSegment(
                  value: ThemeModeType.system,
                  label: Text(AppStrings.themeModeSystem),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeModeType.light,
                  label: Text(AppStrings.themeModeLight),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeModeType.dark,
                  label: Text(AppStrings.themeModeDark),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {themeState.mode},
              onSelectionChanged: (selected) {
                themeNotifier.updateMode(selected.first);
              },
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPaletteOption({
    required BuildContext context,
    required String title,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingMedium,
            horizontal: AppDimensions.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              CircleAvatar(backgroundColor: color, radius: 12),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
