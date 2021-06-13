import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.of(this).size;
}
