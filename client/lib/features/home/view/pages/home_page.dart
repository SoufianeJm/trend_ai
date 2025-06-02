import 'package:flutter/material.dart';
import 'package:client/features/home/view/widgets/home_header.dart';
import 'package:client/features/home/view/widgets/search_bar.dart' as custom;
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/widgets/category_chips_list.dart';
import 'package:client/features/home/view/widgets/section_header.dart';
import 'package:client/features/home/view/widgets/news_card_list.dart';
import 'package:client/features/home/view/widgets/bottom_navbar.dart';
import 'package:client/features/home/view/widgets/popular_tags_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 320,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD7ECFF),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const HomeHeader(),
                        const SizedBox(height: 24),

                        // ✅ Updated SearchBar (no extra bot icon)
                        const custom.SearchBar(),

                        const SizedBox(height: 24),
                        const CategoryChipsList(),
                        const SizedBox(height: 24),
                        const SectionHeader(
                          title: 'Breaking News',
                          onViewMore: null,
                        ),
                        const SizedBox(height: 16),

                        const NewsCardList(),
                        const PopularTagsSection(
                          tags: [
                            '#news',
                            '#today',
                            '#stock',
                            '#business',
                            '#music',
                            '#marketing',
                            '#game',
                            '#crypto',
                            '#lifestyles',
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
