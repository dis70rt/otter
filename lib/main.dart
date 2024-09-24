import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/theme.dart';
import 'package:otter/firebase_options.dart';
import 'package:otter/ui/screens/auth_page.dart';
import 'package:otter/ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: const AuthPage(),
    );
  }
}