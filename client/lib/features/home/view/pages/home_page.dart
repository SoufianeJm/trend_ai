import 'package:flutter/material.dart';
import 'package:client/features/home/view/widgets/home_header.dart';
import 'package:client/features/home/view/widgets/search_bar.dart' as custom;
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/widgets/category_chips_list.dart';
import 'package:client/features/home/view/widgets/section_header.dart';
import 'package:client/features/home/view/widgets/news_card_list.dart';
import 'package:client/features/home/data/repositories/home_repository.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/view/widgets/bottom_navbar.dart';
import 'package:client/features/home/view/widgets/popular_tags_section.dart';
import 'package:client/features/home/view/widgets/news_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/view/widgets/onboarding_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _modalShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowOnboardingModal());
  }

  Future<void> _checkAndShowOnboardingModal() async {
    final box = Hive.box<String>('guest');
    final hasContinuedAsGuest = box.get('hasContinuedAsGuest') == 'true';
    if (!hasContinuedAsGuest && !_modalShown) {
      _modalShown = true;
      await showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OnboardingModal(
          onContinueAsGuest: () async {
            await box.put('hasContinuedAsGuest', 'true');
            if (mounted) Navigator.of(context).pop();
          },
          onEmailSubmit: (email) {
            // For now, just close the modal. Future: redirect to sign in/up.
            if (mounted) Navigator.of(context).pop();
          },
        ),
      );
    }
  }

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

                        FutureBuilder<List<Article>>(
                          future: HomeRepository(DioClient(baseUrl: 'https://api.snrtbotola.ma')).getLatestArticles(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                height: 270,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (_, __) => const SizedBox(
                                    width: 199,
                                    child: NewsCardSkeleton(),
                                  ),
                                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error loading articles'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No articles found'));
                            } else {
                              final articles = snapshot.data!;
                              return NewsCardList(articles: articles);
                            }
                          },
                        ),
                        const PopularTagsSection(),

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
