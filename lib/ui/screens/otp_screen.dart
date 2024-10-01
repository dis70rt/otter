import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/otp_buttons.dart';

import '../../services/auth_provider.dart';

class OTPscreen extends StatefulWidget {
  final String verificationID;
  final String phoneNumber;

  const OTPscreen({
    super.key,
    required this.verificationID,
    required this.phoneNumber,
  });

  @override
  State<OTPscreen> createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  final AuthProvider authProvider = AuthProvider();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  late Timer _timer;
  int _remainingTime = 120;
  bool _canResendCode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResendCode = true;
        });
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Future<void> _resendCode() async {
    if (_canResendCode) {
      setState(() {
        _canResendCode = false;
        _remainingTime = 120;
      });
      _startTimer();
    }
  }

  Future<void> verifyOTP() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String otp = otpControllers.map((ctrl) => ctrl.text).join();
    if (otp.length != 6) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter the complete OTP.";
      });
      return;
    }

    try {
      final authCredential = fbAuth.PhoneAuthProvider.credential(
        verificationId: widget.verificationID,
        smsCode: otp,
      );

      try {
        await authProvider.user?.linkWithCredential(authCredential);
      } on Exception catch (e) {
        log("CHECK ERROR >> ${e.toString()}");
      }
      Navigator.popAndPushNamed(context, "/home");
    } catch (e) {
      log("CHECK ERROR >> ${e.toString()}");
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid OTP. Please try again.";
      });
    }
  }

  void _onOtpFieldChanged(String value, int index) {
    if (value.length == 1 && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }

    // Automatically verify if it's the last field
    if (index == otpControllers.length - 1 && value.length == 1) {
      verifyOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    String ph = widget.phoneNumber;
    String countryCode = ph.substring(0, ph.length - 10);
    String phNo = ph.substring(ph.length - 10);

    return AuthWidget(
      resizeToAvoidBottomInset: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Verification Code",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Text(
            "We have sent the code verification to",
            style: TextStyle(
              color: Colors.white30,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "$countryCode ${phNo[0]}******${phNo.substring(7)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // Handle changing the phone number
                },
                child: const Text(
                  "Change phone number?",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          otpForm(),
          const SizedBox(height: 30),
          Center(
            child: Text(
              _canResendCode
                  ? "You can now resend the code."
                  : "Resend code after: ${_formatTime(_remainingTime)}",
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: 75),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: otpButtons(_canResendCode, _resendCode, verifyOTP),
            ),
        ],
      ),
    );
  }

  Widget otpForm() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
          (index) => _buildOtpTextField(otpControllers[index], index),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(TextEditingController controller, int index) {
    return SizedBox(
      height: 54,
      width: 50,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.blueAccent,
        onChanged: (value) => _onOtpFieldChanged(value, index),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
          filled: true,
        ),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}
