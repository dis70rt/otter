import 'package:flutter/material.dart';

Widget signUp(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Don't have an account?",
        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
      ),
      TextButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed("/signup"),
          style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory),
          child: const Text("Sign Up", style: TextStyle(color: Colors.blue)))
    ],
  );
}

Widget login(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Already have an account?",
        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
      ),
      TextButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed("/login"),
          style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory),
          child: const Text("Login", style: TextStyle(color: Colors.blue)))
    ],
  );
}
