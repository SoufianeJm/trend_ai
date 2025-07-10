import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/view/pages/create_password_page.dart';

class SignupPage extends StatefulWidget {
  final String initialEmail;

  const SignupPage({
    super.key,
    required this.initialEmail,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePasswordPage(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Create Account',
                    style: AppTypography.h4.copyWith(color: Palette.gray900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: AppTypography.bodyRegular16.copyWith(color: Palette.gray400),
                  ),
                  const SizedBox(height: 32),
                  CustomField(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    controller: _firstNameController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your first name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: _lastNameController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your last name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Email',
                    hintText: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppTypography.bodyRegular12.copyWith(color: Palette.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Continue',
                      size: ButtonSize.large,
                      variant: ButtonVariant.primary,
                      onPressed: _isLoading ? null : _handleContinue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium16.copyWith(color: Palette.gray400),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SigninPage(initialEmail: _emailController.text),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: AppTypography.bodyMedium16.copyWith(color: Palette.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
