import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget signupText(BuildContext context, VoidCallback toggle) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "Sign Up",
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = toggle, // Attach the toggle function
            ),
          ],
        ),
      ),
    ],
  );
}

Widget loginText(BuildContext context, VoidCallback toggle) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "Log In",
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = toggle, // Attach the toggle function
            ),
          ],
        ),
      ),
    ],
  );
}
