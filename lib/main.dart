import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/tetris/tetris_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff0f380f),
        accentColor: Color(0xff8bac0f),
        backgroundColor: Color(0xff9bbc0f),
        fontFamily: Configurations.fontFamily,
      ),
      home: TetrisScreen(),
    );
  }
}
