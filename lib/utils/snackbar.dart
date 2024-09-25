import 'package:flutter/material.dart';

class Snackbar {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? message, {Color color = Colors.red}) {
    if (message == null) return;

    final snackBar = SnackBar(
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color)),
          child: Text(
            message,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.transparent);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
