import 'package:flutter/material.dart';
import 'package:otter/services/login_services.dart';

import '../../../main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool isRememberMeChecked = false;

  String? _emailError;
  String? _passwordError;

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
            const SizedBox(height: 0),
            rememberMeAndForgotPassword(
              isRememberMeChecked,
              (bool? value) {
                setState(() {
                  isRememberMeChecked = value ?? false;
                });
              },
            ),
            const SizedBox(height: 25),
            loginButton(context)
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      String? loginError = await userLogin(
        emailController.text,
        passwordController.text,
      );

      if (loginError != null) {
        // Assuming the error is due to invalid login credentials
        setState(() {
          _emailError = null; // Reset email error
          _passwordError = null; // Reset password error

          // You can handle different types of errors here
          if (loginError.contains('email')) {
            _emailError = loginError; // Set error for email
          } else {
            _passwordError = loginError; // Set error for password
          }
        });
      } else {
        // Reset errors on successful login
        setState(() {
          _emailError = null;
          _passwordError = null;
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
        errorText: _emailError, // Display email error here
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget loginButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [
            Colors.blueAccent.shade700,
            Colors.blueAccent.shade400
          ])),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => submit(),
        child: const Text(
          'LOGIN',
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
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        errorText: _passwordError, // Display password error here
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}

Widget rememberMeAndForgotPassword(
    bool isRememberMeChecked, Function(bool?) onRememberMeChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              splashRadius: 0,
              side: const BorderSide(width: 0.7, color: Colors.white54),
              value: isRememberMeChecked,
              onChanged: onRememberMeChanged,
              activeColor: Colors.blueAccent,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text(
              "Remember Me",
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
      TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent),
        onPressed: () {},
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white54),
        ),
      ),
    ],
  );
}
