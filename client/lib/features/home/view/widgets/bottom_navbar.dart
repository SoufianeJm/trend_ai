import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class HomeBottomNavBar extends StatefulWidget {
  const HomeBottomNavBar({super.key});

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  int _currentIndex = 0;

  final List<_NavItem> _items = const [
    _NavItem('Home', 'assets/icons/nav_home.png', 'assets/icons/nav_home_active.png'),
    _NavItem('Explore', 'assets/icons/nav_explore.png', 'assets/icons/nav_explore_active.png'),
    _NavItem('List', 'assets/icons/nav_list.png', 'assets/icons/nav_list_active.png'),
    _NavItem('Profile', 'assets/icons/nav_profile.png', 'assets/icons/nav_profile_active.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = index == _currentIndex;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _currentIndex = index),
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
