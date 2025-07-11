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
import 'package:client/features/home/view/widgets/premium_news_section.dart';
import 'package:client/features/home/view/widgets/premium_news_card.dart';
import 'package:client/features/home/view/widgets/news_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/view/widgets/onboarding_modal.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/core/services/user_service.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _modalShown = false;
  final ScrollController _scrollController = ScrollController();
  
  // Premium News infinite scroll state
  List<Article> _premiumArticles = [];
  bool _isLoadingPremium = false;
  bool _hasReachedEnd = false;
  int _currentPage = 0;
  static const int _pageSize = 3;
  
  // Performance optimizations
  late final HomeRepository _repository;
  Timer? _scrollDebouncer;
  DateTime _lastScrollTime = DateTime.now();
  static const Duration _scrollDebounceDelay = Duration(milliseconds: 100);
  static const double _triggerOffset = 200; // Aggressive prefetching for smooth UX

  @override
  void initState() {
    super.initState();
    // Initialize cached repository to avoid creating new instances
    _repository = HomeRepository(DioClient(baseUrl: 'https://api.snrtbotola.ma'));
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowOnboardingModal());
    _scrollController.addListener(_onScroll);
    _loadInitialPremiumNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollDebouncer?.cancel();
    super.dispose();
  }

  Future<void> _checkAndShowOnboardingModal() async {
    // Generate username if it doesn't exist
    final username = await UserService.getOrGenerateUsername();
    final hasContinuedAsGuest = UserService.hasContinuedAsGuest();

    if (!hasContinuedAsGuest && !_modalShown) {
      _modalShown = true;
      await showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OnboardingModal(
          username: username,
          onContinueAsGuest: () async {
            await UserService.markContinuedAsGuest();
            if (mounted) Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  void _onScroll() {
    // Debounce scroll events to prevent multiple rapid calls
    _scrollDebouncer?.cancel();
    _scrollDebouncer = Timer(_scrollDebounceDelay, () {
      if (!mounted || _isLoadingPremium || _hasReachedEnd) return;
      
      final scrollPosition = _scrollController.position;
      final triggerPoint = scrollPosition.maxScrollExtent - _triggerOffset;
      
      if (scrollPosition.pixels >= triggerPoint) {
        // Additional throttling - prevent calls within 500ms
        final now = DateTime.now();
        if (now.difference(_lastScrollTime).inMilliseconds > 500) {
          _lastScrollTime = now;
          _loadMorePremiumNews();
        }
      }
    });
  }

  Future<void> _loadInitialPremiumNews() async {
    if (_isLoadingPremium) return;
    
    if (mounted) {
      setState(() {
        _isLoadingPremium = true;
      });
    }

    try {
      final articles = await _repository.getPaginatedArticles(
        pageNo: 0,
        pageSize: _pageSize,
      );
      
      if (mounted) {
        setState(() {
          _premiumArticles = articles;
          _currentPage = 0;
          _isLoadingPremium = false;
          _hasReachedEnd = articles.length < _pageSize;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPremium = false;
        });
      }
      print('❌ Error loading initial premium news: $e');
    }
  }

  Future<void> _loadMorePremiumNews() async {
    if (_isLoadingPremium || _hasReachedEnd || !mounted) return;
    
    // Set loading state immediately for instant UI feedback
    if (mounted) {
      setState(() {
        _isLoadingPremium = true;
      });
    }

    try {
      // Load articles in background
      final newArticles = await _repository.getPaginatedArticles(
        pageNo: _currentPage + 1,
        pageSize: _pageSize,
      );
      
      // Batch all state updates in a single setState call
      if (mounted && newArticles.isNotEmpty) {
        setState(() {
          _premiumArticles.addAll(newArticles);
          _currentPage++;
          _isLoadingPremium = false;
          _hasReachedEnd = newArticles.length < _pageSize;
        });
        
        print('✅ Loaded ${newArticles.length} more articles. Total: ${_premiumArticles.length}');
      } else if (mounted) {
        setState(() {
          _isLoadingPremium = false;
          _hasReachedEnd = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPremium = false;
        });
      }
      print('❌ Error loading more premium news: $e');
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
              controller: _scrollController,
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
                        _buildInfiniteScrollPremiumNews(),

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

  Widget _buildInfiniteScrollPremiumNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Premium News',
          style: AppTypography.bodyMedium18.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 16),
        
        // Optimized Premium News Cards with ListView.builder
        if (_premiumArticles.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _premiumArticles.length,
            itemBuilder: (context, index) {
              final article = _premiumArticles[index];
              return PremiumNewsCard(
                key: ValueKey(article.id), // Add key for better performance
                article: article,
                publisherName: 'SNRT News',
                isVerified: true,
              );
            },
          ),
        
        // Optimized loading indicator
        if (_isLoadingPremium)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                ),
              ),
            ),
          ),
        
        // End indicator
        if (_hasReachedEnd && _premiumArticles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'You\'ve reached the end! 🎉',
              style: AppTypography.bodyRegular14.copyWith(
                color: Palette.gray400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

// Reuse the beautiful pulsing dots loader
class _PulsingDotsLoader extends StatefulWidget {
  @override
  State<_PulsingDotsLoader> createState() => _PulsingDotsLoaderState();
}

class _PulsingDotsLoaderState extends State<_PulsingDotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });
    
    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    
    _startAnimation();
  }

  void _startAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: _animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
