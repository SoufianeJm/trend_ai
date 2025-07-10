import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class OnboardingModal extends StatelessWidget {
  final VoidCallback onContinueAsGuest;
  final VoidCallback onContinueWithGoogle;
  final VoidCallback onContinueWithEmail;

  const OnboardingModal({
    super.key,
    required this.onContinueAsGuest,
    required this.onContinueWithGoogle,
    required this.onContinueWithEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay (tappable)
        Positioned.fill(
          child: GestureDetector(
            onTap: onContinueAsGuest,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Modal content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration or logo can go here if needed
                // SizedBox(height: 16),
                OnboardingButton(
                  icon: 'assets/icons/ic-google.png',
                  text: 'Continue with Google',
                  onPressed: onContinueWithGoogle,
                ),
                const SizedBox(height: 8),
                OnboardingButton(
                  icon: 'assets/icons/ic-email.png',
                  text: 'Continue with Email',
                  onPressed: onContinueWithEmail,
                ),
                const SizedBox(height: 8),
                OnboardingButton(
                  icon: 'assets/icons/ic-user.png',
                  text: 'Continue as Guest',
                  onPressed: onContinueAsGuest,
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: 'By continuing you agree to our ',
                    style: AppTypography.bodyMedium12.copyWith(color: Palette.gray400),
                    children: [
                      TextSpan(
                        text: 'terms',
                        style: AppTypography.bodyMedium12.copyWith(
                          color: Palette.gray400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'services',
                        style: AppTypography.bodyMedium12.copyWith(
                          color: Palette.gray400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;

  const OnboardingButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          backgroundColor: Palette.background,
          foregroundColor: Palette.gray900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Palette.gray200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, width: 18, height: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: AppTypography.bodyMedium16,
            ),
          ],
        ),
      ),
    );
  }
} 