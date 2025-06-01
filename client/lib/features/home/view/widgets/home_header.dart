import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/widgets/home_top_bar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeTopBar(),
        const SizedBox(height: 24),
        Text(
          'Explore what Morocco is searching right now.',
          style: AppTypography.h4.copyWith(
            color: Palette.gray900,
          ),
        ),
      ],
    );
  }
}
