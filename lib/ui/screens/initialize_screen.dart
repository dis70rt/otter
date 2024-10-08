import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/constants/lists.dart';
import 'package:otter/main.dart';
import 'package:otter/ui/screens/home_screen.dart';

class InitializeScreen extends StatefulWidget {
  const InitializeScreen({super.key});

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Alignment _alignment;
  final Random _random = Random();

  double _dx = 0.005;
  double _dy = 0.004;

  @override
  void initState() {
    super.initState();

    _alignment =
        Alignment(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1);

    _controller =
        AnimationController(duration: const Duration(minutes: 2), vsync: this)
          ..addListener(_updateGradientPosition);

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      _controller.forward().then((_) => _navigateToAuthPage());
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigateToAuthPage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateGradientPosition() {
    setState(() {
      _alignment = Alignment(_alignment.x + _dx, _alignment.y + _dy);
      if (_alignment.x >= 1.0 || _alignment.x <= -1.0) _dx = -_dx;
      if (_alignment.y >= 1.0 || _alignment.y <= -1.0) _dy = -_dy;
    });
  }

  Future<void> _navigateToAuthPage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: _alignment,
                    radius: 2,
                    colors: [
                      AppColors.secondaryDarkBlue.withOpacity(0.4),
                      AppColors.secondaryDarkBlue.withOpacity(0.15),
                      AppColors.primaryDarkBlue.withOpacity(0.05),
                    ],
                    stops: const [0.2, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please wait while we compile\nall the data for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: AnimatedTextKit(
                  isRepeatingAnimation: true,
                  animatedTexts: List.generate(
                    quotes.length,
                    (index) => TypewriterAnimatedText(
                      quotes[index],
                      speed: const Duration(milliseconds: 100),
                      textStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
