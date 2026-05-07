import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../models/quote_model.dart';
import 'app_button.dart';
import 'app_card.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    required this.onApprove,
    required this.onAskQuestion,
  });

  final QuoteModel quote;
  final VoidCallback onApprove;
  final VoidCallback onAskQuestion;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.secondary.withOpacity(0.14),
                child: Text(
                  quote.expertName.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.secondary,
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
                      quote.expertName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              quote.rating.toStringAsFixed(1),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        _MiniPill(
                          label: quote.level,
                          color: AppColors.primary,
                        ),
                        _MiniPill(
                          label: '${quote.jobsDone} jobs',
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              quote.diagnosisNote,
              style: const TextStyle(
                color: AppColors.secondary,
                fontStyle: FontStyle.italic,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Scope of work',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            quote.scopeOfWork,
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
              _MiniPill(
                label: '${quote.estimatedHours} hrs',
                color: AppColors.primary,
              ),
              _MiniPill(
                label: '${quote.availableDate} • ${quote.availableSlot}',
                color: AppColors.secondary,
              ),
              _MiniPill(
                label: quote.visitType,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _CostRow(label: 'Labour', value: quote.labourCost),
                const SizedBox(height: 8),
                _CostRow(label: 'Parts', value: quote.partsCost),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                _CostRow(label: 'Total', value: quote.total, emphasize: true),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Approve & Pay ₹${quote.total}',
            onPressed: onApprove,
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: TextButton(
              onPressed: onAskQuestion,
              child: const Text('Ask a Question'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final int value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
      fontSize: emphasize ? 16 : 14,
      color: emphasize ? AppColors.textPrimary : AppColors.textSecondary,
    );

    return Row(
      children: [
        Text(label, style: textStyle),
        const Spacer(),
        Text('₹$value', style: textStyle),
      ],
    );
  }
}
