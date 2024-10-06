// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup_form.dart';
import 'package:otter/ui/widgets/Login Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login Elements/oauth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup.dart';
import 'package:otter/ui/widgets/verify_email.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickedLogin;
  const SignUpScreen({super.key, required this.onClickedLogin});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showEmailVerified = false;

  void toggle() => setState(() => showEmailVerified = true);

  @override
  Widget build(BuildContext context) => showEmailVerified
      ? const VerifyEmail()
      : AuthWidget(
          child: Column(
          children: [
            SignUpForm(onSignUp: toggle),
            const SizedBox(height: 30),
            dividerWithText("Or", context),
            const SizedBox(height: 20),
            const OAuth(),
            const SizedBox(height: 40),
            loginText(context, widget.onClickedLogin),
            const SizedBox(height: 20)
          ],
        ));
}
