import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color.fromRGBO(252, 210, 64, 1);
  static const Color blackIconColor = Color.fromRGBO(5, 8, 14, 1);

  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color blue = Colors.blue;
  static const Color red = Colors.red;

  static OutlineInputBorder outlineBorderStyle = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.circular(20),
  );
  static OutlineInputBorder enableBorderStyle = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.circular(20),
  );
  static OutlineInputBorder focusedBorderStyle = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColor.primaryColor, width: 2.0),
    borderRadius: BorderRadius.circular(20),
  );
  static OutlineInputBorder errorBorderStyle = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.circular(20),
  );
}
