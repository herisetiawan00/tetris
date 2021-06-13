import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/common/block_builder.dart';

import 'package:tetr/journey/common/constants.dart';
import 'package:tetr/journey/common/entities/global_index_entity.dart';
import 'package:tetr/journey/tetris/tetris_constants.dart';

class TetrisPreview extends StatefulWidget {
  final void Function(List<Widget>)? setStackWidget;

  const TetrisPreview({Key? key, this.setStackWidget}) : super(key: key);
  @override
  _TetrisPreviewState createState() => _TetrisPreviewState();
}

class _TetrisPreviewState extends State<TetrisPreview> {
  final Block blockSpace = [];
  final Block block = [];
  final BlockKey<GlobalKey> keys = [];
  Timer? timer;

  GlobalIndexEntity globalIndex = GlobalIndexEntity(1, 0);

  Offset? positioned;
  Offset get globalPosition => (keys[globalIndex.indexY][globalIndex.indexX]
          .currentContext!
          .findRenderObject() as RenderBox)
      .localToGlobal(Offset.zero);

  @override
  void initState() {
    reset();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (positioned == null) {
        rotator();
        rotator();
        rotator();
      }
      positioned = globalPosition;
      widget.setStackWidget?.call([
        Positioned(
          top: positioned?.dy,
          left: positioned?.dx,
          child: BlockBuilder(
            block: block,
            size: Configurations.blockWidth,
            emptyColor: Colors.transparent,
          ),
        ),
      ]);
    });
    return Container(
      width: 7 * Configurations.blockWidth,
      height: 18 * Configurations.blockWidth,
      child: BlockBuilder(
        block: blockSpace,
        keys: keys,
        size: Configurations.blockWidth,
      ),
    );
  }

  void reset() {
    timer?.cancel();
    blockSpace
      ..clear()
      ..addAll(
        List.generate(
          TetrisBlock.previewSpace.length,
          (index) => List.from(
            TetrisBlock.previewSpace[index],
          ),
        ),
      );
    block
      ..clear()
      ..addAll(TetrisBlock.cleveLandZ);
    keys
      ..clear()
      ..addAll(
        List.generate(
          18,
          (indexY) => List.generate(
            7,
            (indexX) => GlobalKey(debugLabel: '$indexY-$indexX'),
          ),
        ),
      );
    globalIndex = GlobalIndexEntity(1, 0);
    positioned = null;
    timer = setAutomated();
  }

  Timer setAutomated() => Timer.periodic(Duration(milliseconds: 200), (_) {
        dropBlock(() {}, true);
      });

  void dropBlock([VoidCallback? onStop, shouldRender = false]) {
    if (block.isNotEmpty && !block.last.contains(1)) {
      block.removeLast();
    }

    final bool needBreak = block.isNotEmpty && _posibleGoDown();
    if (globalIndex.indexY == 2) {
      globalIndex.indexX++;
    } else if (globalIndex.indexY == 4) {
      rotator();
    }
    if (needBreak) {
      globalIndex.indexY++;
    } else if (blockSpace.last.first == 0) {
      reset();
    } else {
      onStop?.call();
      Block newSpace = joinBelow(blockSpace, block, null, 1);
      if (newSpace
          .map((e) => e.where((element) => element > 1))
          .where((element) => element.isNotEmpty)
          .isNotEmpty) {
        newSpace = joinBelow(blockSpace, block, null);
      }
      blockSpace
        ..clear()
        ..addAll(newSpace);
      block.clear();
      for (int y = 0; y < blockSpace.length; y++) {
        if (!blockSpace[y].contains(0)) {
          blockSpace
            ..removeAt(y)
            ..insert(0, List.generate(7, (index) => 0));
        }
      }
      globalIndex = GlobalIndexEntity(1, 0);
      positioned = null;
    }
    if (shouldRender) {
      setState(() {});
    }
  }

  bool _posibleGoDown() {
    bool hasBreak = false;
    joinBelow(
      blockSpace,
      block,
      () => hasBreak = true,
      1,
    );

    return !hasBreak;
  }

  Block joinBelow(Block space, Block block,
      [VoidCallback? onBreak, int extraY = 0]) {
    final Block duplicateSpace =
        List.generate(space.length, (index) => List.from(space[index]));
    for (int y = 0; y < block.length; y++) {
      final current = block[y];
      for (int x = 0; x < current.length; x++) {
        final result = duplicateSpace[globalIndex.indexY + y + extraY]
            [globalIndex.indexX + x] += block[y][x];
        if (result > 1 ||
            y == block.length - 1 &&
                x == current.length - 1 &&
                globalIndex.indexY + extraY + block.length >=
                    duplicateSpace.length) {
          onBreak?.call();
          break;
        }
      }
    }

    return duplicateSpace;
  }

  void rotator() {
    final backupedBlock =
        List.generate(block.length, (index) => List<int>.from(block[index]));

    try {
      final Block newBlock = [];
      for (int y = block.length - 1; !y.isNegative; y--) {
        if (newBlock.isEmpty) {
          newBlock.addAll(block[y].map((e) => [e]));
        } else {
          for (int x = 0; x < block[y].length; x++) {
            newBlock[x].add(block[y][x]);
          }
        }
      }
      block
        ..clear()
        ..addAll(newBlock);
      _posibleGoDown();
    } catch (e) {
      globalIndex.indexX = blockSpace.first.length - block.first.length;
      block
        ..clear()
        ..addAll(backupedBlock);
      rotator();
    }
    setState(() {});
  }
}
