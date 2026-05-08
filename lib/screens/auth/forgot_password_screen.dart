import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int currentStep = 0;
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
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
                    Text(
                      currentStep == 0
                          ? 'Enter Email'
                          : currentStep == 1
                              ? 'Enter OTP'
                              : 'New Password',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (currentStep == 0)
                      AppInput(
                        label: 'Email',
                        controller: _emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                      ),
                    if (currentStep == 1)
                      AppInput(
                        label: 'OTP',
                        controller: _otpController,
                        hintText: 'Enter OTP sent to email',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.lock_clock_outlined,
                      ),
                    if (currentStep == 2)
                      AppInput(
                        label: 'New Password',
                        controller: _passwordController,
                        hintText: 'Enter new password',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: currentStep == 2 ? 'Reset Password' : 'Next',
                      onPressed: _nextStep,
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
