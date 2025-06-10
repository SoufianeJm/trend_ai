import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class MetaRow extends StatelessWidget {
  const MetaRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Business', style: AppTypography.bodyMedium14.copyWith(color: Palette.primary)),
        const SizedBox(width: 12),
        Text('1 hour ago', style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400)),
        const Spacer(),
        Icon(Icons.thumb_up_alt_outlined, size: 18, color: Palette.gray400),
        const SizedBox(width: 4),
        Text('2k liked', style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400)),
      ],
    );
  }
}
