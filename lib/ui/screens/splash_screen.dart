import 'dart:math';
import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/main.dart';
import 'package:otter/ui/screens/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Alignment _alignment;

  double _dx = 0.005;
  double _dy = 0.004;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _alignment = Alignment(
      _random.nextDouble() * 2 - 1,
      _random.nextDouble() * 2 - 1,
    );

    _controller = AnimationController(
      duration: const Duration(days: 1),
      vsync: this,
    )..addListener(() {
        _updateGradientPosition();
      });

    _controller.repeat();

    _navigateToAuthPage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateGradientPosition() {
    setState(() {
      _alignment = Alignment(
        _alignment.x + _dx,
        _alignment.y + _dy,
      );

      if (_alignment.x >= 1.0 || _alignment.x <= -1.0) {
        _dx = -_dx;
      }

      if (_alignment.y >= 1.0 || _alignment.y <= -1.0) {
        _dy = -_dy;
      }
    });
  }

  Future<void> _navigateToAuthPage() async {
    await Future.delayed(const Duration(seconds: 5));
    navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1500),
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            blurRadius: 30)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/launcher.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'OTTER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
