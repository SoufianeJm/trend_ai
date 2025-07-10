import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/view/widgets/premium_news_card.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/data/repositories/home_repository.dart';
import 'package:client/core/network/dio_client.dart';

class PremiumNewsSection extends StatefulWidget {
  final VoidCallback? onNeedMoreContent;
  final List<Article>? articles;
  final bool isLoadingMore;
  
  const PremiumNewsSection({
    super.key,
    this.onNeedMoreContent,
    this.articles,
    this.isLoadingMore = false,
  });

  @override
  State<PremiumNewsSection> createState() => _PremiumNewsSectionState();
}

class _PremiumNewsSectionState extends State<PremiumNewsSection> {
  final HomeRepository _repository = HomeRepository(DioClient(baseUrl: 'https://api.snrtbotola.ma'));
  
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  int _currentPage = 0;
  static const int _pageSize = 5; // Load 5 articles per page
  bool _hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    _loadInitialArticles();
  }

  Future<void> _loadInitialArticles() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final articles = await _repository.getPaginatedArticles(
        pageNo: 0,
        pageSize: _pageSize,
      );
      
      setState(() {
        _articles = articles;
        _currentPage = 0;
        _isLoading = false;
        _hasReachedEnd = articles.length < _pageSize;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreArticles() async {
    if (_isLoadingMore || _hasReachedEnd) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newArticles = await _repository.getPaginatedArticles(
        pageNo: _currentPage + 1,
        pageSize: _pageSize,
      );
      
      setState(() {
        _articles.addAll(newArticles);
        _currentPage++;
        _isLoadingMore = false;
        _hasReachedEnd = newArticles.length < _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      // Show error snackbar for load more failures
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more articles'),
            backgroundColor: Palette.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading && _articles.isEmpty) {
      return _buildLoadingCard();
    }
    
    if (_hasError && _articles.isEmpty) {
      return _buildErrorCard();
    }
    
    if (_articles.isEmpty) {
      return _buildHardcodedCard();
    }

    return Column(
      children: [
        // Articles List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _articles.length,
          itemBuilder: (context, index) {
            final article = _articles[index];
            return PremiumNewsCard(
              article: article,
              publisherName: 'SNRT News',
              isVerified: true,
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Load More Button or Loading Animation
        if (_isLoadingMore)
          _buildMinimalLoadingIndicator()
        else if (!_hasReachedEnd && _articles.isNotEmpty)
          _buildLoadMoreButton()
        else if (_hasReachedEnd && _articles.isNotEmpty)
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

  Widget _buildLoadMoreButton() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _loadMoreArticles,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.primary, width: 1.5),
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Palette.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Load More Stories',
                    style: AppTypography.bodyMedium14.copyWith(
                      color: Palette.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Pulsing Dots Animation
          _PulsingDotsLoader(),
          const SizedBox(height: 16),
          // Minimal text
          Text(
            'Loading more stories...',
            style: AppTypography.bodyRegular12.copyWith(
              color: Palette.gray400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: Palette.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.gray200),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Palette.primary,
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: Palette.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.gray200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Palette.gray400,
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load premium news',
              style: AppTypography.bodyRegular14.copyWith(
                color: Palette.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHardcodedCard() {
    // Hardcoded article data as fallback
    final hardcodedArticle = Article(
      id: 9999,
      title: 'Morocco Advances in Digital Innovation with New Tech Hub Initiative',
      description: 'Morocco announces the launch of a new technology hub in Casablanca, aimed at fostering innovation and attracting international tech companies. The initiative is part of the country\'s digital transformation strategy.',
      resume: 'Morocco launches new tech hub in Casablanca for digital innovation',
      categorieLabel: 'Technology',
      image: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
      isVideo: false,
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    return PremiumNewsCard(
      article: hardcodedArticle,
      publisherName: 'Morocco Today',
      isVerified: true,
    );
  }
}

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
