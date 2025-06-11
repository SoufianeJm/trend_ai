import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/pages/search_page.dart';
import 'package:client/features/chatbot/view/pages/chatbot_page.dart';
import 'package:client/features/settings/view/pages/settings_page.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int activeIndex;

  const HomeBottomNavBar({
    super.key,
    this.activeIndex = 0,
  });

  static const List<_NavItem> _items = [
    _NavItem('Home', 'assets/icons/nav_home.png', 'assets/icons/nav_home_active.png'),
    _NavItem('Explore', 'assets/icons/nav_explore.png', 'assets/icons/nav_explore_active.png'),
    _NavItem('Bot', 'assets/icons/nav_robotic.png', 'assets/icons/nav_robotic_active.png'),
    _NavItem('Settings', 'assets/icons/nav_settings.png', 'assets/icons/nav_settings_active.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = index == activeIndex;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              switch (index) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatbotPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                  break;
                // case 0 is Home — assume no action or already handled
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isActive ? item.activeIcon : item.icon,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: AppTypography.bodyMedium12.copyWith(
                    color: isActive ? Palette.primary : Palette.gray900,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  final String activeIcon;

  const _NavItem(this.label, this.icon, this.activeIcon);
}
