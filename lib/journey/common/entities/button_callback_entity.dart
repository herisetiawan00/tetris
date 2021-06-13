import 'package:flutter/material.dart';

class ButtonCallbackEntity {
  final VoidCallback? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;

  ButtonCallbackEntity({
    this.onTap,
    this.onTapDown,
    this.onTapUp,
  });
}
