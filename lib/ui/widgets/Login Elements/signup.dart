import 'package:flutter/material.dart';

Widget signUp() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Don't have an account?",
        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
      ),
      TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory
          ),
          child: const Text("Sign Up", style: TextStyle(color: Colors.blue)))
    ],
  );
}
