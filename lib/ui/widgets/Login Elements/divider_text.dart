import 'package:flutter/material.dart';

Widget dividerWithText(String text, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Divider(color: Colors.white.withOpacity(0.2)), 
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), 
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.bold), 
        ),
      ),
      Expanded(
        child: Divider(
          color: Colors.white.withOpacity(0.2)), 
      ),
    ],
  );
}
