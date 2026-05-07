import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../models/request_model.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'status_badge.dart';
import 'status_stepper.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.onTap,
    this.onPrimaryAction,
  });

  final RequestModel request;
  final VoidCallback onTap;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final config = _configForStatus(request.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.machineName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.issue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  request.updatedAt,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            StatusStepper(status: request.status),
            const SizedBox(height: AppSpacing.md),
            if (config != null)
              _ActionSlot(
                config: config,
                onPressed: onPrimaryAction,
              ),
          ],
        ),
      ),
    );
  }

  _ActionConfig? _configForStatus(String status) {
    switch (status) {
      case 'broadcast':
        return const _ActionConfig(
          label: 'Cancel',
          variant: AppButtonVariant.danger,
        );
      case 'quote_submitted':
        return const _ActionConfig(
          label: 'View Quotes',
          variant: AppButtonVariant.secondary,
          pulse: true,
        );
      case 'en_route':
      case 'in_progress':
        return const _ActionConfig(
          label: 'Open Chat',
          variant: AppButtonVariant.primary,
        );
      case 'pending_confirmation':
        return const _ActionConfig(
          label: 'Confirm Complete ✓',
          variant: AppButtonVariant.primary,
        );
      case 'completed':
        return const _ActionConfig(
          label: 'View Details',
          variant: AppButtonVariant.outline,
        );
      default:
        return null;
    }
  }
}

class _ActionSlot extends StatefulWidget {
  const _ActionSlot({
    required this.config,
    required this.onPressed,
  });

  final _ActionConfig config;
  final VoidCallback? onPressed;

  @override
  State<_ActionSlot> createState() => _ActionSlotState();
}

class _ActionSlotState extends State<_ActionSlot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = AppButton(
      label: widget.config.label,
      variant: widget.config.variant,
      fullWidth: widget.config.label == 'Confirm Complete ✓',
      onPressed: widget.onPressed,
    );

    if (!widget.config.pulse) {
      return Align(alignment: Alignment.centerRight, child: button);
    }

    return FadeTransition(
      opacity: Tween<double>(begin: 0.72, end: 1).animate(_controller),
      child: Align(alignment: Alignment.centerRight, child: button),
    );
  }
}

class _ActionConfig {
  const _ActionConfig({
    required this.label,
    required this.variant,
    this.pulse = false,
  });

  final String label;
  final AppButtonVariant variant;
  final bool pulse;
}
