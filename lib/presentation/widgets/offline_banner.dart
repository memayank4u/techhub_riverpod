import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

class OfflineBanner extends StatelessWidget {
  final bool visible;
  final String message;
  final VoidCallback? onRetry;

  const OfflineBanner({
    super.key,
    required this.visible,
    this.message = AppStrings.commonOfflineBanner,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.offlineAmberBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
        vertical: AppDimensions.spacingSmall,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off,
            color: AppColors.offlineAmber,
            size: AppDimensions.iconMedium,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.onOfflineAmber,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text(
                AppStrings.commonRetry,
                style: TextStyle(
                  color: AppColors.onOfflineAmber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
