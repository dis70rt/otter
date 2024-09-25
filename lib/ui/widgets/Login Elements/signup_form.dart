import 'package:flutter/material.dart';
import 'package:otter/services/login_services.dart';

import '../../../main.dart';

class SignUpForm extends StatefulWidget {
  final VoidCallback onSignUp;
  const SignUpForm({super.key, required this.onSignUp});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            emailField(),
            const SizedBox(height: 15),
            passwordField(),
            const SizedBox(height: 15),
            confirmPasswordField(),
            const SizedBox(height: 25),
            signUpButton(context),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      String? signUpError = await userSignUp(
        emailController.text,
        passwordController.text,
        widget.onSignUp
      );

      if (signUpError != null) {
        setState(() {
          _emailError = null;
          _passwordError = null;
          _confirmPasswordError = null;

          if (signUpError.contains('email')) {
            _emailError = signUpError;
          } else {
            _passwordError = signUpError;
          }
        });
      } else {
        setState(() {
          _emailError = null;
          _passwordError = null;
          _confirmPasswordError = null;
        });

        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    }
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white38),
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        errorText: _emailError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      cursorColor: Colors.blueAccent,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white38),
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        errorText: _passwordError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        } else if (value.length < 8) {
          return 'At least 8 characters long';
        } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
          return 'At least 1 uppercase letter';
        } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
          return 'At least 1 lowercase letter';
        } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
          return 'At least 1 number';
        }
        return null;
      },
    );
  }

  Widget confirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      cursorColor: Colors.blueAccent,
      obscureText: !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: "Re-enter Password",
        labelStyle: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white38),
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        errorText: _confirmPasswordError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Re-enter your password';
        } else if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget signUpButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [
            Colors.blueAccent.shade700,
            Colors.blueAccent.shade400,
          ])),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => submit(),
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
