import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SettingsRow extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;

  const SettingsRow({
    Key? key,
    required this.iconPath,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Palette.backgroundBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTypography.bodyMedium16.copyWith(
                  color: Palette.gray900,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Palette.gray400),
          ],
        ),
      ),
    );
  }
}
