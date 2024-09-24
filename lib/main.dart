import 'package:flutter/material.dart';
import 'package:otter/constants/theme.dart';
import 'package:otter/ui/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: const LoginScreen(),
    );
  }
}