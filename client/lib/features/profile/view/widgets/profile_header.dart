import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';

class ProfileHeader extends StatelessWidget {
  final String? userName;
  final String? userInitials;
  
  const ProfileHeader({
    super.key,
    this.userName,
    this.userInitials,
  });

  String _getUserInitials() {
    if (userInitials != null && userInitials!.isNotEmpty) {
      return userInitials!.toUpperCase();
    }
    
    if (userName != null && userName!.isNotEmpty) {
      final words = userName!.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else if (words.isNotEmpty) {
        return words[0][0].toUpperCase();
      }
    }
    
    return 'U'; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 197, // 120px background + 77px offset from top
      child: Stack(
        children: [
          // Background gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1), // Indigo
                    Color(0xFF8B5CF6), // Purple
                    Color(0xFFEC4899), // Pink
                  ],
                ),
              ),
            ),
          ),
          
          // Avatar and name section
          Positioned(
            top: 77,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Avatar with initial
                Container(
                  width: 89,
                  height: 89,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF10B981), // Emerald
                        Color(0xFF3B82F6), // Blue
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getUserInitials(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 13),
                
                // Username
                Text(
                  userName ?? 'Username',
                  style: AppTypography.bodyMedium18.copyWith(
                    color: const Color(0xFF191919),
                    fontWeight: FontWeight.w500,
                    height: 26/18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
