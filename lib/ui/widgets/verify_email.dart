import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otter/ui/screens/home_screen.dart';
import 'package:otter/utils/snackbar.dart';

import 'auth_widget.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkEmailVerificationStatus();
  }

  Future<void> checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser!;
    
    if (!user.emailVerified) {
      sendVerificationEmail();

      // Start a periodic timer to check email verification status
      timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        await user.reload();
        setState(() {
          isEmailVerified = user.emailVerified;
        });

        if (isEmailVerified) {
          timer?.cancel();
        }
      });
    } else {
      setState(() {
        isEmailVerified = true;
      });
    }
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Snackbar.showSnackBar("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const HomeScreen();
    }

    return AuthWidget(
      child: Column(
        children: [
          const SizedBox(height: 70),
          const Text(
            "A verification email has been\nsent to your email",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(colors: [
                Colors.blueAccent.shade700,
                Colors.blueAccent.shade400,
              ]),
            ),
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: sendVerificationEmail,
              child: const Text(
                'Resend Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 250),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
