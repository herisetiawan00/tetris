import 'package:flutter/material.dart';
import 'package:tetr/journey/common/constants.dart';

class Configurations {
  static BlockSize spaceSize = [10, 25];
  static double blockWidth = 15.0;
  static double opacityEnable = 1.0;
  static double opacityDisable = 0.25;
  static String fontFamily = 'Retro';
  static Color consolePrimaryColor = Colors.red.shade900;
  static Color consoleSecondaryColor = Colors.red;
  static Color consoleIconColor = Colors.white;
  static Color consoleFrameColor = Colors.black;
  static double consoleFrameWidth = 20.0;
}

extension SpaceSizeExtension on BlockSize {
  int get width => this.first;
  int get height => this.last;
}
