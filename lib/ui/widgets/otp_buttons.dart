import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';

Widget otpButtons(bool isResend, VoidCallback resendCode, VoidCallback verify) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buttonResend("RESEND", isResend ? resendCode : null, isResend),
        const SizedBox(width: 10),
        buttonConfirm("CONFIRM", verify),
      ],
    ),
  );
}

Widget _buttonResend(String label, VoidCallback? onTap, bool isResend,
    {double width = 150}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isResend ? Colors.blueAccent : Colors.grey, width: 0.6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isResend ? Colors.blueAccent : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

Widget buttonConfirm(String label, VoidCallback onTap, {double width = 150}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryDarkBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 0.6),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}
