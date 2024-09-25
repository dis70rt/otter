import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otter/ui/widgets/Login%20Elements/divider_text.dart';
import 'package:otter/ui/widgets/Login%20Elements/oauth_widget.dart';
import 'package:otter/ui/widgets/Login%20Elements/signup.dart';
import 'package:otter/ui/widgets/SignUp%20Elements/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset("assets/images/pattern.svg",
                      width: 350))),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500.withOpacity(0.1),
                      gradient: LinearGradient(
                        begin: const Alignment(0, 1),
                        end: const Alignment(0, 0),
                          colors: [Colors.blue.shade900, Colors.blue]),
                      border: const Border(
                          top: BorderSide(color: Colors.white10, width: 2)),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const SignUpForm(),
                          const SizedBox(height: 30),
                          dividerWithText("Or", context),
                          const SizedBox(height: 20),
                          const OAuth(),
                          const SizedBox(height: 40),
                          login(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
