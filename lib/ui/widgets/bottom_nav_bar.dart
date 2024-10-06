import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

Widget buildBottomNavigationBar(void Function(int) onTap, int selectedIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            color: AppColors.secondaryDarkBlue.withOpacity(0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Text(
                    "WATCHLIST",
                    style: TextStyle(
                      color: selectedIndex == 0 ? Colors.white : Colors.white60,
                    ),
                  ),
                  onPressed: () => onTap(0),
                ),
                TextButton(
                  child: Text(
                    "COMPANY",
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.white : Colors.white60,
                    ),
                  ),
                  onPressed: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
