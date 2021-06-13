import 'package:flutter/material.dart';
import 'package:tetr/journey/common/entities/button_callback_entity.dart';

class ConsoleButton extends Padding {
  ConsoleButton({
    EdgeInsets padding = EdgeInsets.zero,
    required IconData icon,
    required ButtonCallbackEntity? callback,
    required double size,
    required Color color,
    required Color iconColor,
  }) : super(
          padding: padding,
          child: GestureDetector(
            onTap: callback?.onTap,
            onTapDown: callback?.onTapDown,
            onTapUp: callback?.onTapUp,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                icon,
                size: size,
                color: iconColor,
              ),
              padding: EdgeInsets.all(5),
            ),
          ),
        );
}
