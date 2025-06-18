import 'package:flutter/material.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class OnboardingModal extends StatefulWidget {
  final VoidCallback onContinueAsGuest;
  final Function(String email) onEmailSubmit;

  const OnboardingModal({
    super.key,
    required this.onContinueAsGuest,
    required this.onEmailSubmit,
  });

  @override
  State<OnboardingModal> createState() => _OnboardingModalState();
}

class _OnboardingModalState extends State<OnboardingModal> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black.withOpacity(0.5), // Overlay
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're one step away 😀",
                  style: AppTypography.h4,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                    style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Enter your email',
                      hintStyle: AppTypography.bodyRegular14.copyWith(color: Palette.gray400),
                      filled: true,
                      fillColor: Palette.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Continue with Email',
                    size: ButtonSize.large,
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onEmailSubmit(_emailController.text.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Continue as Guest',
                      size: ButtonSize.small,
                      variant: ButtonVariant.tertiary,
                      onPressed: widget.onContinueAsGuest,
                      textStyle: AppTypography.bodyRegular12.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Palette.primary,
                      ),
                    ),
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