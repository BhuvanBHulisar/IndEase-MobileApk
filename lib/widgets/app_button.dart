import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';

enum AppButtonVariant { primary, secondary, danger, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.fullWidth = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final bool fullWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final resolvedOnPressed = loading ? null : onPressed;
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 18),
        if (loading || icon != null) const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: resolvedOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => FilledButton(
          onPressed: resolvedOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.danger => OutlinedButton(
          onPressed: resolvedOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: resolvedOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: child,
        ),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
