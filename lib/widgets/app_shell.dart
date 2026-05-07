import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destinations = <_ShellDestination>[
      const _ShellDestination(
        label: 'Home',
        icon: Icons.home_rounded,
        route: '/home',
      ),
      const _ShellDestination(
        label: 'Machines',
        icon: Icons.precision_manufacturing_rounded,
        route: '/machines',
      ),
      const _ShellDestination(
        label: 'Requests',
        icon: Icons.build_circle_rounded,
        route: '/requests',
      ),
      const _ShellDestination(
        label: 'Chat',
        icon: Icons.chat_bubble_rounded,
        route: '/chat',
      ),
      const _ShellDestination(
        label: 'Profile',
        icon: Icons.person_rounded,
        route: '/profile',
      ),
    ];

    final currentIndex = destinations.indexWhere(
      (destination) => location.startsWith(destination.route),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        height: 74,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
        onDestinationSelected: (index) {
          context.go(destinations[index].route);
        },
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
