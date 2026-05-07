import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';
import '../../widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final requestProvider = context.watch<RequestProvider>();
    final completedCount = requestProvider.requests
        .where((request) => request.status == 'completed')
        .length;

    final items = [
      const _ProfileItem('Edit Profile', Icons.person_outline_rounded),
      const _ProfileItem('Change Password', Icons.lock_outline_rounded),
      const _ProfileItem('Notifications', Icons.notifications_none_rounded),
      const _ProfileItem('Help & Support', Icons.help_outline_rounded),
      const _ProfileItem('Terms & Privacy', Icons.description_outlined),
      const _ProfileItem(
        'Logout',
        Icons.logout_rounded,
        color: AppColors.error,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.primary,
                child: Text(
                  auth.firstName.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                auth.fullName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                auth.email,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Fleet Operator'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ProfileStat(
                label: 'Total',
                value: '${requestProvider.machines.length}',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ProfileStat(
                label: 'Completed',
                value: '$completedCount',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ProfileStat(
                label: 'Active',
                value: '${requestProvider.activeRequestsCount}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(item.icon, color: item.color),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: item.color ?? AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  if (item.label == 'Logout') {
                    _showLogoutDialog(context);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem {
  const _ProfileItem(this.label, this.icon, {this.color});

  final String label;
  final IconData icon;
  final Color? color;
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
