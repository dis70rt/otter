// login_screen.dart
import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/login_form.dart';
import 'package:otter/ui/widgets/Login Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login Elements/oauth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onClickedSignUp;
  const LoginScreen({super.key, required this.onClickedSignUp});

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      child: Column(
        children: [
          const Center(
            child: Text(
              "Enter your login information",
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const LoginForm(),
          const SizedBox(height: 30),
          dividerWithText("Or", context),
          const SizedBox(height: 20),
          const OAuth(),
          const SizedBox(height: 40),
          signupText(context, onClickedSignUp),
        ],
      ),
    );
  }
}
