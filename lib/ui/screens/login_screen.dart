import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/Login%20Elements/forgot_password.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/login_form.dart';
import 'package:otter/ui/widgets/Login Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login Elements/oauth_widget.dart';
import 'package:otter/ui/widgets/Login Elements/signup.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginScreen({super.key, required this.onClickedSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isForgot = false;

  void toggle() => setState(() => isForgot = !isForgot);

  @override
  Widget build(BuildContext context) => isForgot
      ? ForgotPassword(onForgotPassword: toggle)
      : AuthWidget(
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Enter your login information",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              LoginForm(onForgotPassword: toggle),
              const SizedBox(height: 30),
              dividerWithText("Or", context),
              const SizedBox(height: 20),
              const OAuth(),
              const SizedBox(height: 40),
              signupText(context, widget.onClickedSignUp),
              const SizedBox(height: 20)
            ],
          ),
        );
}
