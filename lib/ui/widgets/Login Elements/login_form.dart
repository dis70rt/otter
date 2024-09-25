import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otter/services/login_services.dart';

import '../../../main.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgotPassword;
  const LoginForm({super.key, required this.onForgotPassword});

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
              }, widget.onForgotPassword
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
        setState(() {
          _emailError = null;
          _passwordError = null;

          if (loginError.contains('email')) {
            _emailError = loginError;
          } else {
            _passwordError = loginError;
          }
        });
      } else {
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
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w300, color: Colors.white38),
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        errorText: _emailError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value)) {
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
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w300, color: Colors.white38),
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
        errorText: _passwordError,
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
    bool isRememberMeChecked, Function(bool?) onRememberMeChanged, VoidCallback toggle) {
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

      RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "Forgot Password?",
          style:
              const TextStyle(color: Colors.white54, fontWeight: FontWeight.normal),
          recognizer: TapGestureRecognizer()
            ..onTap = toggle, // Attach the toggle function
        )
      ])),
    ],
  );
}
