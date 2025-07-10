import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class OnboardingModal extends StatelessWidget {
  final String username;
  final VoidCallback onContinueAsGuest;

  const OnboardingModal({
    super.key,
    required this.username,
    required this.onContinueAsGuest,
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
                const SizedBox(height: 16),
                
                // Welcome message
                Text(
                  'Welcome $username',
                  style: AppTypography.h3.copyWith(
                    color: Palette.gray900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Continue as Guest button
                OnboardingButton(
                  icon: 'assets/icons/ic-user.png',
                  text: 'Continue as Guest',
                  onPressed: onContinueAsGuest,
                ),
                const SizedBox(height: 16),
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