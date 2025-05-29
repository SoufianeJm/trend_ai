import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/view/widgets/terms_checkbox.dart';
import 'package:client/core/widgets/custom_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

                // 📦 Form Group
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomField(
                        label: 'First Name',
                        hintText: 'Enter your firstname',
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) => value == null || value.isEmpty
                            ? 'First name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomField(
                        label: 'Last Name',
                        hintText: 'Enter your lastname',
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Last name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomField(
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Phone number is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TermsCheckbox(
                        value: _agreedToTerms,
                        onChanged: (val) =>
                            setState(() => _agreedToTerms = val ?? false),
                        onTermsTap: () {
                          // TODO: Navigate to Terms
                        },
                        onPrivacyTap: () {
                          // TODO: Navigate to Privacy
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Sign Up',
                          size: ButtonSize.large,
                          variant: ButtonVariant.primary,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              debugPrint('✅ Form valid. Proceed to sign up.');
                            } else {
                              debugPrint('❌ Form invalid. Check fields.');
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account? ",
                            style: AppTypography.bodyMedium16.copyWith(
                              color: Palette.gray400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to sign-in page
                            },
                            child: Text(
                              "Sign In",
                              style: AppTypography.bodyMedium16.copyWith(
                                color: Palette.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
