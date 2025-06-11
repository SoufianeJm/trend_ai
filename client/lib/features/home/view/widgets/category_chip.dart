import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

import 'package:url_launcher/url_launcher.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String assetPath;

  const CategoryChip({
    super.key,
    required this.label,
    required this.assetPath,
  });

  static const Map<String, String> _categoryUrls = {
    'botola': 'https://play.google.com/store/apps/details?id=com.ionicframework.elbotola609035',
    'live': 'https://play.google.com/store/apps/details?id=ma.snrt.live',
    'news': 'https://play.google.com/store/apps/details?id=ma.snrt.news',
    'forja': 'https://play.google.com/store/apps/details?id=ma.snrt.forja.android.app',
    'ossoud': 'https://play.google.com/store/apps/details?id=ma.snrt.oussoud',
  };

  Future<void> _launchCategoryUrl() async {
    final url = _categoryUrls[label.toLowerCase()];
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.10; // 10% of screen width

    return InkWell(
      borderRadius: BorderRadius.circular(containerSize),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: _launchCategoryUrl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Palette.gray200,
                width: 1,
              ),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: containerSize * 0.5,
                height: containerSize * 0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.bodyMedium10.copyWith(
              color: Palette.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
