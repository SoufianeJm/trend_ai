import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundBlue,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: AppTypography.bodyMedium18.copyWith(
            color: Palette.gray900,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Image.asset('assets/icons/nav_settings.png', width: 24, height: 24),
            onPressed: () {}, // You can add navigation logic here
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.more_vert, color: Palette.gray900),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Palette.backgroundBlue,
                    child: Icon(Icons.person, color: Palette.gray900, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: AppTypography.bodyMedium16.copyWith(
                            color: Palette.gray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'user@email.com',
                          style: AppTypography.bodyRegular14.copyWith(
                            color: Palette.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 20, color: Palette.gray400),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Account',
              style: AppTypography.bodyMedium14.copyWith(
                color: Palette.gray900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Palette.primary),
                    title: Text('Privacy', style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Palette.gray400),
                    onTap: () {},
                  ),
                  Divider(color: Palette.gray100, height: 1),
                  ListTile(
                    leading: Icon(Icons.notifications_none, color: Palette.primary),
                    title: Text('Notifications', style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Palette.gray400),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'More',
              style: AppTypography.bodyMedium14.copyWith(
                color: Palette.gray900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Palette.primary),
                    title: Text('About', style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Palette.gray400),
                    onTap: () {},
                  ),
                  Divider(color: Palette.gray100, height: 1),
                  ListTile(
                    leading: Icon(Icons.logout, color: Palette.error),
                    title: Text('Logout', style: AppTypography.bodyRegular14.copyWith(color: Palette.error)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
