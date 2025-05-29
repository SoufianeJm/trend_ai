import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Enter OTP',
                style: AppTypography.h4.copyWith(color: Palette.gray900),
              ),
              const SizedBox(height: 8),
              Text(
                'Create account and enjoy all services',
                style: AppTypography.bodyRegular16.copyWith(
                  color: Palette.gray400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
