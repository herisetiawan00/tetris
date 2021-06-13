import 'package:flutter/material.dart';

class SideItemBuilder extends StatelessWidget {
  final EdgeInsets padding;
  final String title;
  final Widget value;

  const SideItemBuilder({
    Key? key,
    required this.title,
    required this.value,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff0f380f),
              fontSize: 10,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          value,
        ],
      ),
    );
  }
}
