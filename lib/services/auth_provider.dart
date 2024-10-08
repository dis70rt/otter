import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../ui/screens/otp_screen.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isOtpVerified = false;

  AuthProvider() {
    _auth.userChanges().listen((User? user) {
      _user = user;
      _loadPrefsStatus();
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;
  bool get isOtpVerified => _isOtpVerified;

  Future<void> _loadPrefsStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isOtpVerified = prefs.getBool("otpVerified") ?? false;
    notifyListeners();
  }

  Future<String?> login(
      String email, String password, BuildContext context) async {
    _showLoadingDialog();
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      _hideDialog();
      if (_user?.phoneNumber == null) {
        Navigator.popAndPushNamed(context, "/phone");
      } else {
        sendOTP((_user?.phoneNumber)!, context);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      _hideDialog();
      return _handleAuthError(e);
    } catch (e) {
      _hideDialog();
      log(e.toString());
      return "An unknown error occurred. Please try again.";
    }
  }

  Future<String?> signup(String email, String password) async {
    _showLoadingDialog();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      _hideDialog();
      return null;
    } on FirebaseAuthException catch (e) {
      _hideDialog();
      return _handleAuthError(e);
    } catch (e) {
      _hideDialog();
      log(e.toString());
      return "An unknown error occurred. Please try again.";
    }
  }

  Future<void> logout(BuildContext context) async {
    _auth.signOut();
    _user = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("otpVerified", false);
    notifyListeners();
    Navigator.popAndPushNamed(context, "/auth");
  }

  Future<String?> signInWithGoogle() async {
    _showLoadingDialog();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _hideDialog();
        return 'Google Sign-In canceled by user.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _hideDialog();
      return null;
    } catch (e) {
      _hideDialog();
      log('Error during Google sign-in: $e');
      return 'Error during Google Sign-In.';
    }
  }

  Future<void> sendOTP(String phoneNumber, BuildContext context) async {
    try {
      log('Sending OTP to $phoneNumber');

      await _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await _auth.signInWithCredential(credential);
          log('Verification completed, signed in.');
        },
        verificationFailed: (FirebaseAuthException ex) {
          log('Verification failed: ${ex.message}');

          throw Exception('Verification failed: ${ex.message}');
        },
        codeSent: (String verificationID, int? resendToken) {
          log('Code sent to $phoneNumber, verification ID: $verificationID');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OTPscreen(
                  verificationID: verificationID, phoneNumber: phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          log('Auto-retrieval timeout for verification ID: $verificationID');
        },
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      log('Error sending OTP: $e');
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "The password is incorrect.";
      case 'weak-password':
        return "The password provided is too weak.";
      case 'email-already-in-use':
        return "This email is already in use by another account.";
      default:
        return "An unknown error occurred. Please try again.";
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );
  }

  void _hideDialog() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pop();
    }
  }
}
