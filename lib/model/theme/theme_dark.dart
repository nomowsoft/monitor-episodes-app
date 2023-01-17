import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeDark with Diagnosticable {
  static ThemeData themeDark =
      ThemeData.dark().copyWith(
         primaryColor: const Color(0xff298068),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Loew-Next-Arabic',
          ),
      primaryTextTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Loew-Next-Arabic',
          ),
       secondaryHeaderColor:const Color(0xffb18f6e),   
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(width: 1, color: Color(0xff4B1360)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(width: 1, color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ));
}
