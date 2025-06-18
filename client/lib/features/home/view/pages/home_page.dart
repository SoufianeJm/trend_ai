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
        builder: (context) => _OnboardingModal(
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

class _OnboardingModal extends StatefulWidget {
  final VoidCallback onContinueAsGuest;
  final Function(String email) onEmailSubmit;

  const _OnboardingModal({
    required this.onContinueAsGuest,
    required this.onEmailSubmit,
  });

  @override
  State<_OnboardingModal> createState() => _OnboardingModalState();
}

class _OnboardingModalState extends State<_OnboardingModal> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black.withOpacity(0.5), // Overlay
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're one step away 😀",
                  style: AppTypography.h4,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                    style: AppTypography.bodyRegular14.copyWith(color: Palette.gray900),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Enter your email',
                      hintStyle: AppTypography.bodyRegular14.copyWith(color: Palette.gray400),
                      filled: true,
                      fillColor: Palette.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Continue with Email',
                    size: ButtonSize.large,
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onEmailSubmit(_emailController.text.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Continue as Guest',
                      size: ButtonSize.small,
                      variant: ButtonVariant.tertiary,
                      onPressed: widget.onContinueAsGuest,
                      textStyle: AppTypography.bodyRegular12.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Palette.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
