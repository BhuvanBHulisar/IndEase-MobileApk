import 'package:flutter/material.dart';

import '../constants/colors.dart';

class StatusStepper extends StatelessWidget {
  const StatusStepper({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    const labels = ['Submitted', 'Quote', 'In Progress', 'Done'];
    final currentStep = _statusToStep(status);

    return Row(
      children: List<Widget>.generate(labels.length * 2 - 1, (index) {
        if (index.isOdd) {
          final connectorIndex = index ~/ 2;
          final isActive = connectorIndex < currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.statusColor(status)
                    : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }

        final labelIndex = index ~/ 2;
        final isActive = labelIndex <= currentStep;
        return Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.statusColor(status)
                    : Colors.white,
                border: Border.all(
                  color: isActive
                      ? AppColors.statusColor(status)
                      : AppColors.border,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              labels[labelIndex],
              style: TextStyle(
                fontSize: 10,
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }),
    );
  }

  int _statusToStep(String value) {
    switch (value) {
      case 'broadcast':
        return 0;
      case 'quote_submitted':
      case 'quote_approved':
        return 1;
      case 'en_route':
      case 'in_progress':
        return 2;
      case 'pending_confirmation':
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }
}
