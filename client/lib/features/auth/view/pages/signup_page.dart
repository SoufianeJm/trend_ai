import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/view/widgets/terms_checkbox.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      debugPrint('❌ User must agree to terms.');
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    // TODO: Firebase email signup logic here
    debugPrint('📧 Sign up with email: $email');
    debugPrint('👤 Name: $firstName $lastName');

    setState(() => _isLoading = false);
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'First name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Last name is required'
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
                  const SizedBox(height: 16),
                  TermsCheckbox(
                    value: _agreedToTerms,
                    onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                    onTermsTap: () {},
                    onPrivacyTap: () {},
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Sign Up',
                      size: ButtonSize.large,
                      variant: ButtonVariant.primary,
                      onPressed: _isLoading ? null : _handleSignup,
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
                            MaterialPageRoute(builder: (_) => const SigninPage()),
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
