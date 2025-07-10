import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/enums.dart';
import 'package:client/features/home/view/pages/home_page.dart';

class SigninPage extends StatefulWidget {
  final String initialEmail;
  const SigninPage({
    super.key,
    required this.initialEmail,
  });

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _handleSignin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final client = Client()
      .setEndpoint('https://fra.cloud.appwrite.io/v1')
      .setProject('67dc087f00082b022eca');
    final account = Account(client);
    try {
      await account.createEmailPasswordSession(email: email, password: password);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } on AppwriteException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message ?? 'Sign in failed.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Sign in failed.';
      });
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
                    'Welcome to TrendAI!',
                    style: AppTypography.h4.copyWith(color: Palette.gray900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign In to your account',
                    style: AppTypography.bodyRegular16.copyWith(color: Palette.gray400),
                  ),
                  const SizedBox(height: 32),
                  // Email Field
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
                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                        validator: (value) => value == null || value.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: AppTypography.bodyRegular14.copyWith(color: Palette.gray400),
                          contentPadding: const EdgeInsets.all(16),
                          filled: true,
                          fillColor: Palette.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Palette.gray400,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppTypography.bodyRegular12.copyWith(color: Palette.error),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: Palette.primary,
                            side: const BorderSide(color: Palette.gray300),
                            onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          ),
                          Text(
                            'Remember Me',
                            style: AppTypography.bodyRegular14.copyWith(color: Palette.gray400),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Forgot Password
                        },
                        child: Text(
                          'Forgot Password',
                          style: AppTypography.bodyRegular14.copyWith(color: Palette.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Sign In',
                      size: ButtonSize.large,
                      variant: ButtonVariant.primary,
                      onPressed: _isLoading ? null : _handleSignin,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign Up redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium16.copyWith(color: Palette.gray400),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignupPage(initialEmail: _emailController.text),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
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
