import 'package:flutter/material.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/otp_buttons.dart';
import 'package:otter/ui/widgets/otp_form.dart';

class OTPscreen extends StatefulWidget {
  final String verificationID;
  final String phoneNumber;
  const OTPscreen(
      {super.key, required this.verificationID, required this.phoneNumber});

  @override
  State<OTPscreen> createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
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
              "Verification Code",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.start,
            ),
            const Text(
              "We have sent the code verification to",
              style: TextStyle(
                  color: Colors.white30,
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
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
            const OtpForm(),
            const SizedBox(height: 30),
            const Center(
                child: Text(
              "Resend code after:",
              style: TextStyle(color: Colors.white38),
            )),
            const SizedBox(height: 75),
            Align(
              alignment: Alignment.bottomCenter,
              child: otpButtons(),
            ),
          ],
        ));
  }
}
