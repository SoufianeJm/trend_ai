import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Settings',
        style: AppTypography.bodyMedium18.copyWith(
          color: Palette.gray900,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 24, height: 24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: const [],
    );
  }
}
