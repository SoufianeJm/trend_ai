import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/pages/coming_soon_page.dart';
import 'package:client/core/services/appwrite_auth_service.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Client()
      ..setEndpoint('https://cloud.appwrite.io/v1')
      ..setProject('67dc087f00082b022eca');
    final userService = AppwriteUserService(client);
    return FutureBuilder<models.User?>(
      future: userService.getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final fullName = user?.name ?? 'Random User';
        final initial = (fullName.isNotEmpty) ? fullName[0].toUpperCase() : 'U';
        return Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6), // Reasonable padding
              decoration: BoxDecoration(
                color: Palette.background,
                shape: BoxShape.circle,
                border: Border.all(color: Palette.gray200, width: 2),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: AppTypography.h4.copyWith(color: Palette.gray900),
                ),
              ),
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
                  fullName,
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
      },
    );
  }
}
