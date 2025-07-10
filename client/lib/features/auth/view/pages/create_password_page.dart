import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/pages/otp_page.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/enums.dart';
import 'package:client/features/home/view/pages/home_page.dart';

class CreatePasswordPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const CreatePasswordPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _error;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final client = Client()
      .setEndpoint('https://fra.cloud.appwrite.io/v1')
      .setProject('67dc087f00082b022eca');
    final account = Account(client);
    try {
      // Create user
      await account.create(
        userId: ID.unique(),
        email: widget.email,
        password: _passwordController.text,
        name: '${widget.firstName} ${widget.lastName}',
      );
      // Create session for the new user
      await account.createEmailPasswordSession(
        email: widget.email,
        password: _passwordController.text,
      );
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
          (route) => false,
        );
      }
    } on AppwriteException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message ?? 'Sign up failed.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Sign up failed.';
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
                    'Create password',
                    style: AppTypography.h4.copyWith(color: Palette.gray900),
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 16),
                  Text(
                    'Confirm Password',
                    style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Minimum 6 characters';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
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
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Palette.gray400,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
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
                      text: 'Sign Up',
                      size: ButtonSize.large,
                      variant: ButtonVariant.primary,
                      onPressed: _isLoading ? null : _handleSignUp,
                    ),
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