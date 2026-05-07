import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../models/chat_model.dart';
import 'app_button.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.onPayNow,
  });

  final ChatMessage message;
  final VoidCallback? onPayNow;

  @override
  Widget build(BuildContext context) {
    if (message.type == ChatMessageType.invoice) {
      return _InvoiceMessage(
        amount: message.amount ?? 0,
        time: message.time,
        onPayNow: onPayNow,
      );
    }

    if (message.type == ChatMessageType.appointment) {
      return _AppointmentMessage(
        date: message.appointmentDate ?? '',
        timeSlot: message.appointmentTime ?? '',
        status: message.appointmentStatus ?? 'Pending',
        time: message.time,
      );
    }

    final bubbleColor =
        message.isConsumer ? AppColors.primary : AppColors.card;
    final borderColor =
        message.isConsumer ? AppColors.primary : AppColors.border;
    final textColor = message.isConsumer ? Colors.white : AppColors.textPrimary;
    final alignment =
        message.isConsumer ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: message.isConsumer
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text ?? '',
              style: TextStyle(color: textColor, height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              message.time,
              style: TextStyle(
                color: message.isConsumer
                    ? Colors.white70
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceMessage extends StatelessWidget {
  const _InvoiceMessage({
    required this.amount,
    required this.time,
    required this.onPayNow,
  });

  final int amount;
  final String time;
  final VoidCallback? onPayNow;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SERVICE INVOICE',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '₹$amount',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Pay Now',
              onPressed: onPayNow,
              fullWidth: false,
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentMessage extends StatelessWidget {
  const _AppointmentMessage({
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.time,
  });

  final String date;
  final String timeSlot;
  final String status;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📅', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$date • $timeSlot',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
