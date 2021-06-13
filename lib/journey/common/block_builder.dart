import 'package:flutter/material.dart';

import 'package:tetr/journey/common/constants.dart';
import 'package:tetr/journey/common/extensions/number_extensions.dart';
import 'package:tetr/journey/common/extensions/context_extensions.dart';

class BlockBuilder extends StatelessWidget {
  final Block block;
  final double size;
  final BlockKey? keys;
  final Color? emptyColor;
  final Color? filledColor;
  final double opacity;

  const BlockBuilder({
    Key? key,
    required this.block,
    required this.size,
    this.keys,
    this.emptyColor,
    this.filledColor,
    this.opacity = 1.0,
  }) : super(key: key);

  Color _emptyColor(BuildContext context) =>
      emptyColor ?? context.theme.backgroundColor;
  Color _filledColor(BuildContext context) =>
      filledColor ?? context.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: List.generate(block.length, (indexY) {
          final row = block[indexY];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              row.length,
              (indexX) {
                final _block = row[indexX];
                return Container(
                  key: keys != null ? keys![indexY][indexX] : null,
                  width: size,
                  height: size,
                  color: _block.isEmpty
                      ? _emptyColor(context)
                      : _filledColor(context),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
