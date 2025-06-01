import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/mock/mock_news.dart';

class NewsCard extends StatelessWidget {
  final NewsItem item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.imagePath,
                  width: 240,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Image.asset(
                  'assets/icons/bookmark_empty.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                item.category,
                style: AppTypography.bodyMedium10.copyWith(color: Palette.primary),
              ),
              const Spacer(),
              Row(
                children: [
                  Image.asset('assets/icons/clock.png', width: 12, height: 12),
                  const SizedBox(width: 6),
                  Text(
                    item.timeAgo,
                    style: AppTypography.bodyRegular10.copyWith(color: Palette.gray400),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: AppTypography.bodyMedium14.copyWith(color: Palette.gray900),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Palette.gray200, width: 1),
                ),
                child: Image.asset(
                  item.publisherLogo,
                  width: 12,
                  height: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.publisher,
                style: AppTypography.bodyMedium10.copyWith(color: Palette.gray400),
              ),
              const Spacer(),
              Image.asset('assets/icons/more.png', width: 16, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
