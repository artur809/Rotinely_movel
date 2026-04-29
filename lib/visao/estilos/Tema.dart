import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData temaEscuro() {
  final baseTheme = ThemeData(
    fontFamily: "Open Sans",
  );
  return baseTheme.copyWith(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF16A34A),
    primaryColorLight: Color(0xFFDCFCE7),
    primaryColorDark: Color(0xFF15803D),
    highlightColor: Colors.white,
    //primaryColorBrightness: Brightness.dark,
    //accentColor: Colors.white,
  );
}


