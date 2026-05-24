import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: AppColors.error,
        ),
      );
    } else {
      // Pre-load requests after successful login
      await context.read<RequestProvider>().fetchRequests();
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: AppSpacing.xl),
                    AppInput(
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      label: 'Password',
                      controller: _passwordController,
                      hintText: 'Enter password',
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => AppButton(
                        label: auth.isLoading ? 'Logging in...' : 'Login',
                        onPressed: auth.isLoading ? null : _login,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => AppButton(
                        label: 'Demo Login (Offline Mode)',
                        variant: AppButtonVariant.outline,
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final authProv = context.read<AuthProvider>();
                                await authProv.loginDemo();
                                if (!mounted) return;
                                await context.read<RequestProvider>().fetchRequests();
                                if (mounted) context.go('/home');
                              },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => AppButton(
                        label: 'Continue with Google',
                        variant: AppButtonVariant.outline,
                        icon: Icons.account_circle_outlined,
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final authProv = context.read<AuthProvider>();
                                await authProv.loginWithGoogle();
                                if (!mounted) return;
                                if (authProv.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProv.error!),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                } else {
                                  await context.read<RequestProvider>().fetchRequests();
                                  if (mounted) context.go('/home');
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot Password?'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
