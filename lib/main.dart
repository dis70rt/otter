import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/theme.dart';
import 'package:otter/firebase_options.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:otter/services/database_provider.dart';
import 'package:otter/ui/screens/add_phone.dart';
import 'package:otter/ui/screens/home_screen.dart';
import 'package:otter/ui/screens/splash_screen.dart';
import 'package:otter/utils/snackbar.dart';
import 'package:provider/provider.dart';

import 'ui/screens/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FireStoreProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Snackbar.messengerKey,
        navigatorKey: navigatorKey,
        theme: AppTheme.dark,
        routes: {
          "/home": (context) => const HomeScreen(),
          "/auth": (context) => const AuthPage(),
          "/phone": (context) => const AddPhone(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
