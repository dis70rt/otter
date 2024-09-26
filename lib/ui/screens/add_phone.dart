import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/otp_buttons.dart';

import '../widgets/auth_widget.dart';

class AddPhone extends StatefulWidget {
  const AddPhone({super.key});

  @override
  State<AddPhone> createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> {
  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      resizeToAvoidBottomInset: true,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "Add phone number",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        const Text(
          "Input a phone number you'd like to add to your account",
          style: TextStyle(
              color: Colors.white30,
              fontWeight: FontWeight.normal,
              fontSize: 14),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "+91 6******066",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                  text: "Change phone number?",
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // const OtpForm(),
        const SizedBox(height: 30),
        const Center(
            child: Text(
          "Resend code after:",
          style: TextStyle(color: Colors.white38),
        )),
        const SizedBox(height: 75),
        Align(
          alignment: Alignment.bottomCenter,
          child: buttonConfirm("Continue", () {}, width: MediaQuery.of(context).size.width),
        ),
      ],
    ));
  }
}