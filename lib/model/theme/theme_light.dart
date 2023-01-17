import 'package:flutter/material.dart';

class ThemeLight {
  static ThemeData themeLight = ThemeData.light().copyWith(
      primaryColor: const Color(0xff298068),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Loew-Next-Arabic',
          ),
      primaryTextTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Loew-Next-Arabic',
          ),
      secondaryHeaderColor: const Color(0xffb18f6e),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1, color: Color(0xffD0D2DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1, color: Color(0xff4B1360)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1, color: Colors.red),
        ),
        errorStyle:const TextStyle(
            color: Colors.red, fontSize: 10, fontWeight: FontWeight.w500),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ));
}
//C3DA44