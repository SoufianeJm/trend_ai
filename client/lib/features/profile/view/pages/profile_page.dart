import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/profile/view/widgets/profile_header.dart';
import 'package:client/core/services/user_service.dart';
import 'package:client/features/bookmarks/data/services/saved_articles_service.dart';
import 'package:client/features/bookmarks/view/widgets/saved_article_card.dart';
import 'package:client/features/home/data/models/article_model.dart';

// Updated with Figma app bar design - Fixed negative margin error
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';
  String _userInitials = 'L';
  int _selectedTabIndex = 0;
  List<Article> _savedArticles = [];
  bool _isLoadingSavedArticles = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadSavedArticles();
  }
  
  Future<void> _loadSavedArticles() async {
    setState(() {
      _isLoadingSavedArticles = true;
    });
    
    try {
      final savedArticles = await SavedArticlesService.getSavedArticles();
      setState(() {
        _savedArticles = savedArticles;
        _isLoadingSavedArticles = false;
      });
    } catch (e) {
      print('Error loading saved articles: $e');
      setState(() {
        _isLoadingSavedArticles = false;
      });
    }
  }
  
  void _onArticleRemoved() {
    // Refresh the saved articles list when an article is removed
    _loadSavedArticles();
  }

  Future<void> _loadUsername() async {
    try {
      final username = await UserService.getOrGenerateUsername();
      final initials = _generateInitials(username);
      setState(() {
        _username = username;
        _userInitials = initials;
      });
    } catch (e) {
      print('Error loading username: $e');
      setState(() {
        _username = 'Guest User';
        _userInitials = 'GU';
      });
    }
  }

  String _generateInitials(String username) {
    if (username.isEmpty) return 'GU';
    
    // Extract capital letters from username (excluding numbers)
    final capitals = username.split('').where((char) => 
      char.toUpperCase() == char && 
      char.isNotEmpty && 
      RegExp(r'[A-Z]').hasMatch(char)
    ).toList();
    
    if (capitals.length >= 2) {
      return capitals.take(2).join('');
    } else if (capitals.length == 1) {
      // Find the next alphabetic character after the first capital
      final firstCapitalIndex = username.indexOf(capitals.first);
      for (int i = firstCapitalIndex + 1; i < username.length; i++) {
        if (RegExp(r'[A-Za-z]').hasMatch(username[i])) {
          return capitals.first + username[i].toUpperCase();
        }
      }
      return capitals.first + 'U';
    } else {
      // Fallback: take first two alphabetic characters
      final alphabetic = username.split('').where((char) => RegExp(r'[A-Za-z]').hasMatch(char)).toList();
      if (alphabetic.length >= 2) {
        return alphabetic.take(2).join('').toUpperCase();
      } else if (alphabetic.length == 1) {
        return alphabetic.first.toUpperCase() + 'U';
      } else {
        return 'GU';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Figma App Bar with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Empty space (invisible placeholder)
                      const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                      
                      // Center: Profile text
                      Text(
                        'Profile',
                        style: AppTypography.bodyMedium18.copyWith(
                          color: const Color(0xFF191919),
                          fontWeight: FontWeight.w500,
                          height: 26/18, // lineHeight: 26px, fontSize: 18px
                        ),
                      ),
                      
                      // Right: Settings icon
                      GestureDetector(
                        onTap: () {
                          // Handle settings tap
                          print('Settings tapped');
                        },
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.settings_outlined,
                            size: 24,
                            color: Palette.gray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Profile Header (full width)
              ProfileHeader(
                userName: _username,
                userInitials: _userInitials,
              ),
              
              // Content sections with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Stats Section
                    _buildStatsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Tabs Section
                    _buildTabsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Articles Content
                    _buildArticlesContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('17', 'Articles'),
        _buildStatItem('412', 'Followers'),
        _buildStatItem('120', 'Following'),
      ],
    );
  }
  
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTypography.bodyBold16.copyWith(
            color: const Color(0xFF45AEFF),
            height: 24/16,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodyRegular12.copyWith(
            color: const Color(0xFFA3A3A3),
            height: 18/12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabsSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActiveTab('Saved Articles'),
          const SizedBox(width: 16),
          _buildInactiveTab('Read Articles'),
        ],
      ),
    );
  }
  
  Widget _buildActiveTab(String title) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF45AEFF),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          title,
          style: AppTypography.bodyMedium14.copyWith(
            color: Colors.white,
            height: 20/14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildInactiveTab(String title) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          title,
          style: AppTypography.bodyRegular14.copyWith(
            color: const Color(0xFFA3A3A3),
            height: 20/14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildArticlesContent() {
    if (_selectedTabIndex == 0) {
      // Saved Articles Tab
      return _buildSavedArticlesSection();
    } else {
      // Read Articles Tab (placeholder for now)
      return _buildReadArticlesSection();
    }
  }
  
  Widget _buildSavedArticlesSection() {
    if (_isLoadingSavedArticles) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_savedArticles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.bookmark_border,
              size: 48,
              color: Palette.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Saved Articles',
              style: AppTypography.bodyMedium18.copyWith(
                color: Palette.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save articles you want to read later by tapping the bookmark icon.',
              style: AppTypography.bodyRegular14.copyWith(
                color: Palette.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Articles (${_savedArticles.length})',
          style: AppTypography.bodyMedium16.copyWith(
            color: Palette.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _savedArticles.length,
          itemBuilder: (context, index) {
            return SavedArticleCard(
              article: _savedArticles[index],
              onRemoved: _onArticleRemoved,
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildReadArticlesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 48,
            color: Palette.gray400,
          ),
          const SizedBox(height: 16),
          Text(
            'Read Articles',
            style: AppTypography.bodyMedium18.copyWith(
              color: Palette.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This feature will track articles you\'ve read and show them here.',
            style: AppTypography.bodyRegular14.copyWith(
              color: Palette.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
