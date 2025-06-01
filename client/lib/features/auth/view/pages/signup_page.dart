import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/services/appwrite_auth_service.dart';
import 'package:client/features/auth/view/pages/otp_verification_page.dart';

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

  final AppwriteAuthService _authService = AppwriteAuthService();

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (!mounted) return;

      final userId = await _authService.sendEmailOtp(_emailController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            userId: userId,
            email: _emailController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          ),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
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
                    'Sign Up',
                    style: AppTypography.h4.copyWith(color: Palette.gray900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create account and enjoy all services',
                    style: AppTypography.bodyRegular16.copyWith(color: Palette.gray400),
                  ),
                  const SizedBox(height: 32),
                  CustomField(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Email',
                    hintText: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || !value.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),
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
                        "Have an account? ",
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
                          "Sign In",
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
