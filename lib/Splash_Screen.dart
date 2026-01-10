import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/UI/auth/loginPage.dart';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await CommonService.getSessionToken();
    final userId = await CommonService.getUserId();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else if (userId == null || userId.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    }
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.mid,
              AppColors.primary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 3, child: _logo()),
              Expanded(flex: 1, child: _loading()),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _appIcon(),
                const SizedBox(height: 30),
                _title(),
                const SizedBox(height: 10),
                _tagline(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.chat_bubble_rounded,
        color: AppColors.primary,
        size: 60,
      ),
    );
  }

  Widget _title() => const Text(
    'ChatConnect',
    style: TextStyle(
      color: AppColors.colorWhite,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.3,
    ),
  );

  Widget _tagline() => const Text(
    'Connect. Chat. Share.',
    style: TextStyle(color: AppColors.lightText, fontSize: 16),
  );

  Widget _loading() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      CircularProgressIndicator(color: AppColors.primary),
      SizedBox(height: 15),
      Text('Initializing...', style: TextStyle(color: AppColors.lightText)),
    ],
  );

  Widget _footer() => const Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: Text(
      'Secure messaging for everyone',
      style: TextStyle(color: AppColors.lightText),
    ),
  );
}
