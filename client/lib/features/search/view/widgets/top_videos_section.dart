import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class TopVideosSection extends StatelessWidget {
  const TopVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        'image': 'assets/images/trending1.webp',
        'duration': '03:07',
        'title': 'Tech Giant Unveils Revolutionary AI-powered Device hello',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
        'date': 'Jun 10, 2023',
      },
      {
        'image': 'assets/images/news_ronaldo.webp',
        'duration': '03:07',
        'title': 'Tech Giant Unveils Revolutionary AI-powered Device hello',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
        'date': 'Jun 10, 2023',
      },
      {
        'image': 'assets/images/news_sample.webp',
        'duration': '03:07',
        'title': 'Tech Giant Unveils Revolutionary AI-powered Device hello',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
        'date': 'Jun 10, 2023',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top videos', style: AppTypography.bodyBold16),
              Text('view more', style: AppTypography.bodyMedium14.copyWith(color: Palette.gray500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: videos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final video = videos[index];
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Palette.gray200, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video thumbnail with overlays
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            video['image']!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          // Play icon
                          Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white70,
                              ),
                              child: Center(
                                child: Icon(Icons.play_arrow, size: 24, color: Colors.black),
                              ),
                            ),
                          ),
                          // Duration label
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                video['duration']!,
                                style: AppTypography.bodyMedium12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    video['title']!,
                    style: AppTypography.bodyMedium14.copyWith(color: Palette.gray700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
} 