import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/theme.dart';
import 'package:otter/firebase_options.dart';
import 'package:otter/ui/screens/add_phone.dart';
import 'package:otter/ui/screens/auth_screen.dart';
import 'package:otter/ui/screens/home_screen.dart';
import 'package:otter/ui/screens/login_screen.dart';
import 'package:otter/utils/snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Snackbar.messengerKey,
      navigatorKey: navigatorKey,
      theme: AppTheme.dark,
      routes: {
        "/home": (context) => const HomeScreen()
      },
      home: const AuthScreen()// const AuthPage(),
    );
  }
}