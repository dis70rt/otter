import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otter/constants/images.dart';

class OAuth extends StatelessWidget {
  const OAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      children: [oauthGoogle(), oauthApple()],
    );
  }
}

Widget oauthGoogle() {
  return Container(
    width: 150,
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30, width: 0.6)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Logo.google,
          width: 20,
        ),
        const SizedBox(width: 10),
        const Text(
          "GOOGLE",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    ),
  );
}

Widget oauthApple() {
  return Center(
    child: Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30, width: 0.6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Logo.apple,
            width: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            "APPLE",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    ),
  );
}
