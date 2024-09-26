import 'package:flutter/material.dart';

Widget otpButtons() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buttonResend("RESEND", () {}),
        const SizedBox(width: 10),
        buttonConfirm("CONFIRM", () {}),
      ],
    ),
  );
}

  Widget _buttonResend(String label, Function()? onTap, {double width = 150}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent, width: 0.6),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonConfirm(String label, Function()? onTap, {double width = 150}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent, width: 0.6),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }