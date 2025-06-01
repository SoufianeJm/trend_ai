import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/services/appwrite_auth_service.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/pages/placeholder_home.dart';

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
  final _authService = AppwriteAuthService();

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

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await _authService.login(email, password);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PlaceholderHome()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
      debugPrint('❌ Sign in failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                    'Welcome Back!',
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
