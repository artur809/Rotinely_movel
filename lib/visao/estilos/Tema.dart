import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData temaEscuro() {
  final baseTheme = ThemeData(
    fontFamily: "Open Sans",
  );
  return baseTheme.copyWith(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1668A3),
    primaryColorLight: Color(0xFFB7D7DC),
    primaryColorDark: Color(0xFF154B80),
    highlightColor: Colors.white,
    //primaryColorBrightness: Brightness.dark,
    //accentColor: Colors.white,
  );
}


