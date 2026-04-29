import 'dart:ui';

import 'package:flutter/material.dart';

class EstilosTextosCustomizado {
  static TextStyle formField(BuildContext context) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }
  static TextStyle formField2(BuildContext context) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle subTitle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }

  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }

  static TextStyle body(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }
}