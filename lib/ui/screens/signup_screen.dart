// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup_form.dart';
import 'package:otter/ui/widgets/Login Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login Elements/oauth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback onClickedLogin;
  const SignUpScreen({super.key, required this.onClickedLogin});

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      child: Column(
        children: [
          const SignUpForm(),
          const SizedBox(height: 30),
          dividerWithText("Or", context),
          const SizedBox(height: 20),
          const OAuth(),
          const SizedBox(height: 40),
          loginText(context, onClickedLogin)
        ],
      ),
    );
  }
}
