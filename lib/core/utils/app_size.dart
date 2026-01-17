import 'package:flutter/material.dart';

class AppSize {
  static late double _screenHeight;
  static late double _screenWidth;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenHeight = size.height;
    _screenWidth = size.width;
  }

  static double h(double percent) => _screenHeight * (percent / 100);
  static double w(double percent) => _screenWidth * (percent / 100);
}
