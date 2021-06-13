import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/common/constants.dart';
import 'package:tetr/journey/common/extensions/number_extensions.dart';
import 'package:tetr/journey/common/entities/global_index_entity.dart';
import 'package:tetr/journey/tetris/tetris_constants.dart';

class TetrisUtils {
  bool isGameOver = false;
  bool isPaused = false;
  Offset? positioned;
  final Block blockSpace = [];
  final Block block = [];
  final Block nextBlock = [];
  final BlockKey<GlobalKey> globalKeys = [];
  Timer? timer;
  int score = 0;
  int highscore = 0;

  VoidCallback? requestRender;

  GlobalIndexEntity globalIndex = GlobalIndexEntity(0, 0);

  static Block get getRandomBlock =>
      TetrisBlock.getAll[Random().nextInt(TetrisBlock.getAll.length)];

  Offset get globalPosition =>
      (globalKeys[globalIndex.indexY][globalIndex.indexX]
              .currentContext!
              .findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);

  void checkIsGameOver() {
    if (blockSpace.first.where((element) => element > 0).isNotEmpty) {
      final Block _nextBlock =
          List.generate(2, (y) => List.generate(3, (x) => 0));
      nextBlock
        ..clear()
        ..addAll(_nextBlock);
      isGameOver = true;
      block.clear();
      timer?.cancel();
    }
  }

  void resetor() {
    timer?.cancel();
    isPaused = false;
    isGameOver = false;
    score = 0;
    block.clear();
    nextBlock
      ..clear()
      ..addAll(TetrisUtils.getRandomBlock);
    blockSpace
      ..clear()
      ..addAll(
        List.generate(
          Configurations.spaceSize.height,
          (index) => List.generate(
            Configurations.spaceSize.width,
            (index) => 0,
          ),
        ),
      );
    globalKeys
      ..clear()
      ..addAll(
        List.generate(
          Configurations.spaceSize.height,
          (indexY) => List.generate(
            Configurations.spaceSize.width,
            (indexX) => GlobalKey(debugLabel: '${indexY.alphabet}$indexX'),
          ),
        ),
      );
    positioned = null;
    globalIndex = GlobalIndexEntity(0, 0);
    requestRender?.call();
  }

  pauser() {
    if (isPaused) {
      timer = dropper();
    } else {
      timer?.cancel();
    }
    isPaused = !isPaused;
    requestRender?.call();
  }

  spawner() {
    final Block _block = List.from(nextBlock);
    nextBlock
      ..clear()
      ..addAll(TetrisUtils.getRandomBlock);
    final indexX =
        ((blockSpace.first.length / 2) - (_block.first.length / 2)).toInt();

    globalIndex
      ..indexX = indexX
      ..indexY = 0;
    positioned = globalPosition;
    block
      ..clear()
      ..addAll(_block);

    requestRender?.call();
    timer?.cancel();
    timer = dropper();
  }

  Timer dropper([Duration? duration]) =>
      Timer.periodic(duration ?? Duration(milliseconds: 400), (_) {
        dropBlock(_.cancel, true);
      });

  void onStartDrop() {
    timer?.cancel();
    timer = dropper(Duration(milliseconds: 100));
  }

  void onEndDrop() {
    timer?.cancel();
    timer = dropper();
  }

  void drop() {
    timer?.cancel();
    bool stop = false;

    while (!stop) {
      dropBlock(() => stop = true);
    }
  }

  void dropBlock([VoidCallback? onStop, shouldRender = false]) {
    if (!block.last.contains(1)) {
      block.removeLast();
    }

    final bool needBreak = _posibleGoDown();
    if (needBreak) {
      globalIndex.indexY++;
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
      int bonus = 0;
      for (int y = 0; y < blockSpace.length; y++) {
        if (!blockSpace[y].contains(0)) {
          blockSpace
            ..removeAt(y)
            ..insert(0, List.generate(10, (index) => 0));
          score += 100 + (bonus * 50);
          bonus++;
        }
      }
      highscore = max<int>(score, highscore);

      spawner();
    }
    if (shouldRender) {
      requestRender?.call();
    }
  }

  bool possibleMove(int indexX) {
    bool isPossible = true;
    for (int y = 0; y < block.length; y++) {
      final current = block[y];
      final List<int> currentSpace =
          List.from(blockSpace[globalIndex.indexY + y]);
      for (int x = 0; x < current.length; x++) {
        final result =
            currentSpace[globalIndex.indexX + indexX + x] += current[x];
        if (result > 1) {
          isPossible = false;
        }
      }
    }
    return isPossible;
  }

  void mover(int indexX) {
    if (indexX.isNegative &&
        !(globalIndex.indexX - 1).isNegative &&
        possibleMove(indexX)) {
      globalIndex.indexX--;
    } else if (!indexX.isNegative &&
        (globalIndex.indexX + 1) <=
            blockSpace.first.length - block.first.length &&
        possibleMove(indexX)) {
      globalIndex.indexX++;
    }
    requestRender?.call();
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
    requestRender?.call();
  }
}
