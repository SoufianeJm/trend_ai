import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class CustomField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;

  const CustomField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium14.copyWith(color: Palette.gray900),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: hintText,
            hintStyle: AppTypography.bodyRegular14.copyWith(color: Palette.gray400),
            filled: true,
            fillColor: Palette.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
