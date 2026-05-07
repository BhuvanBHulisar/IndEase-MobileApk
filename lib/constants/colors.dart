import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0D9488);
  static const Color secondary = Color(0xFF6366F1);
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Map<String, Color> statusColors = {
    'broadcast': Color(0xFFF59E0B),
    'quote_submitted': Color(0xFF6366F1),
    'quote_approved': Color(0xFF3B82F6),
    'en_route': Color(0xFF8B5CF6),
    'in_progress': Color(0xFFF97316),
    'pending_confirmation': Color(0xFFF59E0B),
    'completed': Color(0xFF10B981),
    'cancelled': Color(0xFFEF4444),
  };

  static Color statusColor(String status) =>
      statusColors[status] ?? AppColors.secondary;

  static String statusLabel(String status) {
    switch (status) {
      case 'quote_submitted':
        return 'Quote Submitted';
      case 'quote_approved':
        return 'Quote Approved';
      case 'en_route':
        return 'En Route';
      case 'in_progress':
        return 'In Progress';
      case 'pending_confirmation':
        return 'Pending Confirmation';
      default:
        return status
            .split('_')
            .map(
              (part) =>
                  '${part.substring(0, 1).toUpperCase()}${part.substring(1)}',
            )
            .join(' ');
    }
  }
}
