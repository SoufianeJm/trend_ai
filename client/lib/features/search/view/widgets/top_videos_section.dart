import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/service/search_service.dart';
import 'package:shimmer/shimmer.dart';

class TopVideosSection extends StatefulWidget {
  final String query;
  const TopVideosSection({super.key, required this.query});

  @override
  State<TopVideosSection> createState() => _TopVideosSectionState();
}

class _TopVideosSectionState extends State<TopVideosSection> {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTopVideos();
  }

  Future<void> _fetchTopVideos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final result = await SearchService.search(widget.query);
      final results = result['results'] ?? [];
      final videos = results
          .where((item) => item['type'] == 'video')
          .map<Map<String, dynamic>>((item) {
            final extra = item['extra'] ?? {};
            String imagePath = extra['image'] ?? '';
            String imageUrl = imagePath.startsWith('http')
                ? imagePath
                : (imagePath.isNotEmpty ? 'https://cdn.snrtbotola.ma$imagePath' : '');
            return {
              'title': item['title'] ?? '',
              'imageUrl': imageUrl,
              'duration': extra['duration'] ?? '',
            };
          })
          .toList();
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        _isLoading
            ? Shimmer.fromColors(
                baseColor: Palette.gray100,
                highlightColor: Palette.gray200,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Palette.gray200, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: double.infinity,
                              height: 120,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Palette.gray100,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white70,
                                      ),
                                      child: const Icon(Icons.play_arrow, size: 24, color: Colors.black26),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Palette.gray100,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : _hasError
                ? const Center(child: Text('Failed to load videos'))
                : _videos.isEmpty
                    ? const Center(child: Text('No videos found'))
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _videos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final video = _videos[index];
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
                                        video['imageUrl'] != ''
                                            ? Image.network(
                                                video['imageUrl']!,
                                                width: double.infinity,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  height: 120,
                                                  color: Palette.gray100,
                                                  child: const Icon(Icons.broken_image, size: 40, color: Palette.gray400),
                                                ),
                                              )
                                            : Container(
                                                height: 120,
                                                color: Palette.gray100,
                                                child: const Icon(Icons.image, size: 40, color: Palette.gray400),
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
                                            child: const Center(
                                              child: Icon(Icons.play_arrow, size: 24, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        // Duration label
                                        if (video['duration'] != null && video['duration'] != '')
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