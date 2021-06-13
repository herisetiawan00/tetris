import 'package:flutter/material.dart';
import 'package:tetr/journey/common/constants.dart';
import 'package:tetr/journey/landing/landing_screen.dart';
import 'package:tetr/journey/tetris/tetris_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll = {
    RouteList.home: (context) => LandingScreen(),
    RouteList.tetris: (context) => TetrisScreen(),
  };
}
