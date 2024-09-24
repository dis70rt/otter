import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/Login%20Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login%20Elements/login_form.dart';
import 'package:otter/ui/widgets/Login%20Elements/oauth_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }
}
