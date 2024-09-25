import 'package:flutter/material.dart';
import 'package:otter/ui/screens/login_screen.dart';
import 'package:otter/ui/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
    ? LoginScreen(onClickedSignUp: toggle)
    : SignUpScreen(onClickedLogin: toggle);

    void toggle() => setState(() => isLogin = !isLogin);
}