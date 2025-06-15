import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/pages/coming_soon_page.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/avatar.png',
          width: 36,
          height: 36,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: AppTypography.bodyRegular10.copyWith(
                color: Palette.gray400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Random User',
              style: AppTypography.bodyMedium14.copyWith(
                color: Palette.gray900,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ComingSoonPage()),
            );
          },
          child: Image.asset(
            'assets/icons/bell.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
