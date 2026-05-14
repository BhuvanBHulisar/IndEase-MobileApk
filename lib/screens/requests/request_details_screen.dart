import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../models/request_model.dart';
import '../../providers/request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_badge.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<RequestProvider>().requestById(requestId);
    if (request == null) {
      return const Scaffold(
        body: Center(child: Text('Request not found')),
      );
    }

    final action = _actionForRequest(request);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      bottomNavigationBar: action == null
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: AppButton(
                label: action.$1,
                variant: action.$2,
                onPressed: () => _handleAction(context, request),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Analysis',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Machine type detected: ${request.aiMachineType}',
                        ),
                        const SizedBox(height: 6),
                        Text('Issue summary: ${request.aiIssue}'),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Confidence: ${(request.aiConfidence * 100).round()}%',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: request.aiConfidence,
                          color: AppColors.primary,
                          backgroundColor: AppColors.border,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          request.machineName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      StatusBadge(status: request.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    request.issue,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(label: 'Urgency: ${request.urgency}'),
                      _InfoPill(label: 'Date: ${request.preferredDate}'),
                      _InfoPill(label: 'Budget: ${request.budgetHint}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Status Timeline',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._buildTimeline(request.status),
            if (request.expertName != null) ...[
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Assigned Expert',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primary.withOpacity(0.14),
                      child: Text(
                        request.expertName!.substring(0, 1),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.expertName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '4.8 stars',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Bronze',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(String status) {
    const labels = [
      'Submitted',
      'Quote Received',
      'In Progress',
      'Confirm',
      'Done',
    ];
    final currentIndex = switch (status) {
      'broadcast' => 0,
      'quote_submitted' || 'quote_approved' => 1,
      'en_route' || 'in_progress' => 2,
      'pending_confirmation' => 3,
      'completed' => 4,
      _ => 0,
    };

    return List<Widget>.generate(labels.length, (index) {
      final active = index <= currentIndex;
      final isCurrent = index == currentIndex;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: active
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (index != labels.length - 1)
                Container(
                  width: 2,
                  height: 32,
                  color: active ? AppColors.primary : AppColors.border,
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              labels[index],
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      );
    });
  }

  (String, AppButtonVariant)? _actionForRequest(RequestModel request) {
    switch (request.status) {
      case 'quote_submitted':
        return ('View Quotes', AppButtonVariant.secondary);
      case 'in_progress':
      case 'en_route':
        return ('Open Chat', AppButtonVariant.primary);
      case 'pending_confirmation':
        return ('Confirm Complete', AppButtonVariant.primary);
      case 'broadcast':
        return ('Cancel Request', AppButtonVariant.danger);
      default:
        return null;
    }
  }

  Future<void> _handleAction(BuildContext context, RequestModel request) async {
    final provider = context.read<RequestProvider>();
    switch (request.status) {
      case 'quote_submitted':
        context.push('/requests/${request.id}/quotes');
        break;
      case 'in_progress':
      case 'en_route':
        context.push('/chat/${request.id == '2' ? '2' : '1'}');
        break;
      case 'pending_confirmation':
        await provider.confirmCompletion(request.id);
        break;
      case 'broadcast':
        await provider.cancelRequest(request.id);
        if (context.mounted) {
          context.pop();
        }
        break;
    }
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
