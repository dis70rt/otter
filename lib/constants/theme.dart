import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';

class AppTheme {
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.primaryDarkBlue,
    appBarTheme: const AppBarTheme(backgroundColor:AppColors.secondaryDarkBlue),
      inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white, width: 0.5)),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white70),
    ),
    
    floatingLabelStyle: const TextStyle(color: Colors.white),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white70),
    
  ));
}
