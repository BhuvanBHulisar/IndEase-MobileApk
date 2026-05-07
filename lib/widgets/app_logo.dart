import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: compact ? 52 : 72,
          height: compact ? 52 : 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.precision_manufacturing_rounded,
            color: AppColors.primary,
            size: 34,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'IndEase',
          style: TextStyle(
            fontSize: compact ? 28 : 34,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Industrial Repair Made Easy',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
