import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/pages/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    debugPrint('[SplashScreen] _navigateToHome: started');
    try {
      // Add a small delay to show the splash screen
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('[SplashScreen] _navigateToHome: delay finished');
      
      if (!mounted) {
        debugPrint('[SplashScreen] _navigateToHome: not mounted, returning');
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e, stack) {
      debugPrint('[SplashScreen] _navigateToHome: ERROR: $e');
      debugPrint('[SplashScreen] _navigateToHome: STACKTRACE: $stack');
    }
    debugPrint('[SplashScreen] _navigateToHome: finished');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: Center(
        child: Image.asset(
          'assets/images/trendai_logo.png', 
          width: 160,
        ),
      ),
    );
  }
}
