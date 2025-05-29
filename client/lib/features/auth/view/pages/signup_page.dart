import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/view/widgets/terms_checkbox.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Sign Up',
                  style: AppTypography.h4.copyWith(color: Palette.gray900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create account and enjoy all services',
                  style: AppTypography.bodyRegular16.copyWith(
                    color: Palette.gray400,
                  ),
                ),
                const SizedBox(height: 32),

                // 📦 Group of 3 fields + checkbox with 16px spacing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomField(
                      label: 'First Name',
                      hintText: 'Enter your firstname',
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      label: 'Last Name',
                      hintText: 'Enter your lastname',
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomField(
                      label: 'Email',
                      hintText: 'Enter your email address',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TermsCheckbox(
                      value: _agreedToTerms,
                      onChanged: (val) =>
                          setState(() => _agreedToTerms = val ?? false),
                      onTermsTap: () {
                        // TODO: Navigate to Terms of Service
                      },
                      onPrivacyTap: () {
                        // TODO: Navigate to Privacy Policy
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
