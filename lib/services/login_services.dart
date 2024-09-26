import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

Future<String?> userLogin(String email, String password) async {
  _showLoadingDialog();
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    _hideDialog();

    return null;
  } on FirebaseAuthException catch (e) {
    log(e.code);
    _hideDialog();

    String errorMessage;
    switch (e.code) {
      case 'invalid-email':
        errorMessage = "The email address is not valid.";
        break;
      case 'user-disabled':
        errorMessage = "This user has been disabled.";
        break;
      case 'user-not-found':
        errorMessage = "No user found with this email.";
        break;
      case 'wrong-password':
        errorMessage = "The password is incorrect.";
        break;
      case 'invalid-credential':
        errorMessage = "The Username or Password is Incorrect.";
        break;
      default:
        errorMessage = "An unknown error occurred. Please try again.";
    }
    return errorMessage;
  } catch (e) {
    log(e.toString());

    return "An unknown error occurred. Please try again.";
  }
}

userLogout() async {
  return FirebaseAuth.instance.signOut();
}

Future<String?> userSignUp(
    String email, String password, VoidCallback toggle) async {
  _showLoadingDialog();
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    _hideDialog();
    _showSuccessDialog('Sign-Up Successful!');
    toggle();
    return null;
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    _hideDialog();

    String errorMessage;
    switch (e.code) {
      case 'weak-password':
        errorMessage = "The password provided is too weak.";
        break;
      case 'email-already-in-use':
        errorMessage = "This email is already in use by another account.";
        break;
      case 'invalid-email':
        errorMessage = "The email address is not valid.";
        break;
      default:
        errorMessage = "An unknown error occurred. Please try again.";
    }
    return errorMessage;
  } catch (e) {
    log(e.toString());
    _hideDialog();
    return "An unknown error occurred. Please try again.";
  }
}

Future<void> signInWithGoogle() async {
  _showLoadingDialog();

  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      _hideDialog();
      _showErrorDialog('Google Sign-In canceled by user.');
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    _hideDialog();

    _showSuccessDialog('Sign-in Successful!');
  } catch (e) {
    _hideDialog();
    log('Error during Google sign-in: $e');
    _showErrorDialog('Error during Google Sign-In.');
  }
}

void _showLoadingDialog() {
  navigatorKey.currentState?.push(
    CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => const CupertinoAlertDialog(
        title: Text('Signing In...'),
        content: Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeCap: StrokeCap.round,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void _hideDialog() {
  navigatorKey.currentState?.pop();
}

void _showErrorDialog(String message) {
  navigatorKey.currentState?.push(
    CupertinoPageRoute(
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => _hideDialog(),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

void _showSuccessDialog(String message) {
  navigatorKey.currentState?.push(
    CupertinoPageRoute(
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => _hideDialog(),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

Future<void> sendOTP(String phoneNumber) async {
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException ex) {
        throw Exception('Verification failed: ${ex.message}');
      },
      codeSent: (String verificationID, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationID) {},
      phoneNumber: phoneNumber,
    );
  } catch (e) {
    log('Error sending OTP: $e');
  }
}
