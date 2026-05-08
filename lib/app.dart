import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/machines/machine_form_screen.dart';
import 'screens/machines/machines_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/requests/create_request_screen.dart';
import 'screens/requests/request_details_screen.dart';
import 'screens/requests/requests_screen.dart';
import 'screens/requests/view_quotes_screen.dart';
import 'screens/payment/payment_confirmation_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'widgets/app_shell.dart';

class IndEaseApp extends StatefulWidget {
  const IndEaseApp({super.key, required this.authProvider});

  final AuthProvider authProvider;

  @override
  State<IndEaseApp> createState() => _IndEaseAppState();
}

class _IndEaseAppState extends State<IndEaseApp> {
  late final GoRouter _router = _buildRouter(widget.authProvider);

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    return MaterialApp.router(
      title: 'IndEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.card,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.workSansTextTheme(baseTextTheme).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }

  GoRouter _buildRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        if (isLoggedIn && isAuthRoute) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(
            location: state.uri.toString(),
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/machines',
              builder: (context, state) => const MachinesScreen(),
            ),
            GoRoute(
              path: '/requests',
              builder: (context, state) => const RequestsScreen(),
            ),
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatListScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/machines/add',
          builder: (context, state) => const MachineFormScreen(),
        ),
        GoRoute(
          path: '/machines/edit/:id',
          builder: (context, state) => MachineFormScreen(
            machineId: state.pathParameters['id'],
          ),
        ),
        GoRoute(
          path: '/requests/create',
          builder: (context, state) => const CreateRequestScreen(),
        ),
        GoRoute(
          path: '/requests/:id',
          builder: (context, state) => RequestDetailsScreen(
            requestId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/requests/:id/quotes',
          builder: (context, state) => ViewQuotesScreen(
            requestId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) => ChatScreen(
            threadId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/payment/:requestId',
          builder: (context, state) => PaymentConfirmationScreen(
            requestId: state.pathParameters['requestId']!,
          ),
        ),
        GoRoute(
          path: '/payment/:requestId/success',
          builder: (context, state) => PaymentSuccessScreen(
            requestId: state.pathParameters['requestId']!,
          ),
        ),
      ],
    );
  }
}
