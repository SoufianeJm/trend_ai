import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/services/user_service.dart';
import 'package:client/features/profile/view/pages/profile_page.dart';
import 'package:client/features/settings/view/pages/settings_page.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: UserService.getOrGenerateUsername(),
      builder: (context, snapshot) {
        final username = snapshot.data ?? 'Guest User';
        final initial = username.isNotEmpty ? username[0].toUpperCase() : 'G';

        return _buildTopBar(username, initial);
      },
    );
  }

  Widget _buildTopBar(String fullName, String initial) {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF87CEEB), // Sky Blue
                      Color(0xFFE6F3FF), // Very Light Blue
                    ],
                  ),
                  border: Border.all(color: Palette.gray200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF87CEEB).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
              child: Image.asset(
                'assets/icons/nav_settings.png',
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
