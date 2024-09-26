import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otter/ui/screens/auth_screen.dart';
import 'package:otter/ui/screens/home_screen.dart';
import 'package:otter/ui/widgets/verify_email.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          if (snapshot.data?.emailVerified == true) {
            return const HomeScreen();
          } else {
            return const VerifyEmail();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
