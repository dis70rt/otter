import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otter/constants/images.dart';
import 'package:otter/services/login_services.dart';

class OAuth extends StatelessWidget {
  const OAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        oauthButton(Logo.google, "GOOGLE", signInWithGoogle),
        const SizedBox(width: 20),
        oauthButton(Logo.apple, "APPLE", () {}),
      ],
    );
  }

  Widget oauthButton(String logoPath, String label, Function()? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white30, width: 0.6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(logoPath, width: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
