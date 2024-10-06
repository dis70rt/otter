import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/ui/widgets/Login%20Elements/signup.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/utils/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  final VoidCallback onForgotPassword;
  const ForgotPassword({super.key, required this.onForgotPassword});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      resizeToAvoidBottomInset: true,
        child: Form(
      key: _formKey,
      child: Column(
        children: [
          const Center(
            child: Text(
              "Enter the email address associated with your account and we'll send you a link to reset your password.",
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 30),
          emailField(),
          const SizedBox(height: 20),
          submitButton(context),
          const SizedBox(height: 40),
          forgotText(context, widget.onForgotPassword),
          const SizedBox(height: 20)
        ],
      ),
    ));
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [
            AppColors.secondaryDarkBlue,
            Colors.blueAccent.shade400
          ])),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => resetPassword(emailController.text.trim()),
        child: const Text(
          'RESET PASSWORD',
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

  Future resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Snackbar.showSnackBar("Password Reset email send", color: Colors.green);
    } on FirebaseAuthException {
      Snackbar.showSnackBar("Failed to send link for password reset");
    }
  }
}
