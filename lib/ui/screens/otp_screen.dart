import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otter/ui/widgets/auth_widget.dart';
import 'package:otter/ui/widgets/otp_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<ValueNotifier<String>> otpValues =
      List.generate(6, (_) => ValueNotifier<String>(''));
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
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
          _canResendCode = _remainingTime == 0;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var notifier in otpValues) {
      notifier.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
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

    String otp = otpValues.map((notifier) => notifier.value).join();
    if (otp.length != 6) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter the complete OTP.";
      });
      return;
    }

    try {
      final authCredential = fb_auth.PhoneAuthProvider.credential(
        verificationId: widget.verificationID,
        smsCode: otp,
      );
      log(authCredential.toString());
      try {
        await authProvider.user?.linkWithCredential(authCredential);
      } on Exception catch (e) {
        log(e.toString());
      }
      await fb_auth.FirebaseAuth.instance.signInWithCredential(authCredential);
      log(fb_auth.FirebaseAuth.instance.currentUser.toString());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("otpVerified", true);
      Navigator.popAndPushNamed(context, "/init");
    } on fb_auth.FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? "Invalid OTP. Please try again.";
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }

  void _onOtpFieldChanged(String value, int index) {
    if (value.length == 1) {
      if (index < otpValues.length - 1) {
        FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
      } else {
        verifyOTP();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    String ph = widget.phoneNumber;
    String countryCode = ph.substring(0, ph.length - 10);
    String phNo = ph.substring(ph.length - 10);

    return Stack(
      children: [
        AuthWidget(
          resizeToAvoidBottomInset: true,
          child: SingleChildScrollView(
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
                      onTap: () {},
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: otpButtons(_canResendCode, _resendCode, verifyOTP),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget otpForm() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildOtpTextField(otpValues[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(ValueNotifier<String> valueNotifier, int index) {
    return ValueListenableBuilder<String>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return TextFormField(
          onChanged: (value) {
            valueNotifier.value = value;
            _onOtpFieldChanged(value, index);
          },
          cursorColor: Colors.blueAccent,
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
          focusNode: otpFocusNodes[index],
          onTap: () {
            FocusScope.of(context).requestFocus(otpFocusNodes[index]);
          },
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}
