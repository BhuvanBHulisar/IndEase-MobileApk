import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/mock_data.dart';
import '../../constants/spacing.dart';
import '../../providers/auth_provider.dart';
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

  void _login() {
    context.read<AuthProvider>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    context.go('/home');
  }

  void _demoLogin() {
    setState(() {
      _emailController.text = demoEmail;
      _passwordController.text = demoPassword;
    });
    context.read<AuthProvider>().demoLogin();
    context.go('/home');
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
                      hintText: 'demo@consumer.com',
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
                    AppButton(
                      label: 'Login',
                      onPressed: _login,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: 'Demo Login',
                      onPressed: _demoLogin,
                      variant: AppButtonVariant.outline,
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
