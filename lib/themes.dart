import 'package:flutter/material.dart';

ThemeData lightTheme= ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900
  ));

ThemeData darkTheme= ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.grey.shade900,
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade700,
        tertiary: Colors.grey.shade800,
        inversePrimary: Colors.grey.shade300
    ));