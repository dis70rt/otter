import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otter/main.dart';
import 'package:otter/utils/snackbar.dart';

Future<String?> userLogin(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return null;
  } on FirebaseAuthException catch (e) {
    log(e.code);

    switch (e.code) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "The password is incorrect.";
      case 'invalid-credential':
        return "The Username or Password is Incorrect.";
      default:
        return "An unknown error occurred. Please try again.";
    }
  } catch (e) {
    log(e.toString());
    return "An unknown error occurred. Please try again.";
  }
}

void userLogout() {
  FirebaseAuth.instance.signOut();
}

Future<String?> userSignUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return null; // Account created successfully
  } on FirebaseAuthException catch (e) {
    log(e.toString());

    switch (e.code) {
      case 'weak-password':
        return "The password provided is too weak.";
      case 'email-already-in-use':
        return "This email is already in use by another account.";
      case 'invalid-email':
        return "The email address is not valid.";
      default:
        return "An unknown error occurred. Please try again.";
    }
  } catch (e) {
    log(e.toString());
    return "An unknown error occurred. Please try again.";
  }
}

