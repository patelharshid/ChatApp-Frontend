import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/UI/auth/loginPage.dart';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
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

  bool _showRetryOption = false;

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else if (userId == null || userId.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    }
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 800)),
        Future.delayed(const Duration(milliseconds: 600)),
        Future.delayed(const Duration(milliseconds: 1000)),
        Future.delayed(const Duration(milliseconds: 700)),
      ]);

      await Future.delayed(const Duration(milliseconds: 3000));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (_) {
      if (mounted) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) setState(() => _showRetryOption = true);
        });
      }
    }
  }

  void _retryInitialization() {
    setState(() => _showRetryOption = false);
    _initializeApp();
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
        width: double.infinity,
        decoration: _gradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 3, child: _logoWithAnimation()),
              Expanded(flex: 1, child: _loadingOrRetry()),
              _footerText(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _gradientBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1976D2), Color(0xFF2196F3), Color(0xFF64B5F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  Widget _logoWithAnimation() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _appIcon(),
                const SizedBox(height: 30),
                _titleText(),
                const SizedBox(height: 10),
                _taglineText(),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.chat_bubble, color: Colors.blue, size: 60),
    );
  }

  Widget _titleText() {
    return const Text(
      'ChatConnect',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _taglineText() {
    return Text(
      'Connect. Chat. Share.',
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
    );
  }

  Widget _loadingOrRetry() {
    return _showRetryOption ? _retryWidget() : _loadingWidget();
  }

  Widget _loadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
        const SizedBox(height: 15),
        Text(
          'Initializing...',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
      ],
    );
  }

  Widget _retryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Connection timeout',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'Retry',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _footerText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Secure messaging for everyone',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
