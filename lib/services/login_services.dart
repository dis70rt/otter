import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otter/main.dart';

void userLogin(TextEditingController emailController,
    TextEditingController passwordController, BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()));

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  } catch (e) {
    log(1);
  }

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

void userLogout() {
  FirebaseAuth.instance.signOut();
}
