import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetr/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Gameboy'),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class GlobalIndex {
  int indexX;
  int indexY;

  GlobalIndex(this.indexX, this.indexY);

  @override
  String toString() => 'GlobalIndex(x: $indexX, y: $indexY)';
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isGameOver = false;
  bool isPaused = false;
  Offset? positioned;
  final List<List<int>> blockSpace = [];
  final List<List<int>> block = [];
  final List<List<int>> nextBlock = [];
  final List<List<GlobalKey>> globalKeys = [];
  Timer? timer;
  int score = 0;
  int highscore = 0;

  GlobalIndex globalIndex = GlobalIndex(0, 0);

  @override
  void initState() {
    _resetor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blockWidth = 15.0;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final keyPosition = (globalKeys[globalIndex.indexY][globalIndex.indexX]
              .currentContext!
              .findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
      if (positioned != keyPosition) {
        setState(() {
          if (positioned == null) {
            _spawner();
          }
          positioned = (globalKeys[globalIndex.indexY][globalIndex.indexX]
                  .currentContext!
                  .findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);
        });
      }
    });

    if (blockSpace.first.where((element) => element > 0).isNotEmpty) {
      isGameOver = true;
      block.clear();
      timer?.cancel();
    }
    return Scaffold(
      body: Container(
        color: Colors.red[900],
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Center(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width * 0.1),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff9bbc0f),
                          border: Border.all(
                            width: 20,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: blockWidth * blockSpace.first.length,
                              height: blockWidth * blockSpace.length,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: isGameOver || isPaused ? 0.25 : 1,
                                    child: Column(
                                      children: List.generate(blockSpace.length,
                                          (indexY) {
                                        final row = blockSpace[indexY];
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            row.length,
                                            (indexX) {
                                              final _block = row[indexX];
                                              return Container(
                                                key: globalKeys[indexY][indexX],
                                                width: blockWidth,
                                                height: blockWidth,
                                                child: Text(
                                                  _block.toString(),
                                                  style: TextStyle(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                color: _block == 0
                                                    ? Colors.transparent
                                                    : Color(0xff0f380f),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isGameOver || isPaused,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          isGameOver ? 'Game Over' : 'Paused',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff0f380f),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 25 * 15,
                              child: VerticalDivider(
                                thickness: 2,
                                color: Color(0xff0f380f),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Next:',
                                    style: TextStyle(
                                      color: Color(0xff0f380f),
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 48.0,
                                    child: Column(
                                      children: List.generate(
                                        nextBlock.length,
                                        (indexY) {
                                          final row = nextBlock[indexY];
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                              row.length,
                                              (indexX) {
                                                final _block = row[indexX];
                                                return Opacity(
                                                  opacity: 1.0,
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    color: _block > 0
                                                        ? Color(0xff0f380f)
                                                        : Color(0xff8bac0f),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Score:',
                                    style: TextStyle(
                                      color: Color(0xff0f380f),
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '$score',
                                    style: TextStyle(
                                      color: Color(0xff0f380f),
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'High:',
                                    style: TextStyle(
                                      color: Color(0xff0f380f),
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '$highscore',
                                    style: TextStyle(
                                      color: Color(0xff0f380f),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: positioned?.dy,
                  left: positioned?.dx,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: block.isEmpty
                        ? [Container()]
                        : List.generate(block.length, (indexY) {
                            final row = block[indexY];
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                row.length,
                                (indexX) {
                                  final _block = row[indexX];
                                  return Opacity(
                                    opacity:
                                        (isGameOver || isPaused ? 0.25 : 1.0) *
                                            _block,
                                    child: Container(
                                      width: blockWidth,
                                      height: blockWidth,
                                      color: Color(0xff0f380f),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                  ),
                ),
              ],
            ),
            Spacer(),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: isGameOver ? null : _pauser,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Icon(
                            Icons.pause,
                            size: 10,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: _resetor,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Icon(
                            Icons.refresh,
                            size: 10,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: isGameOver || isPaused ? null : _rotator,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: isGameOver || isPaused
                                    ? null
                                    : () => _mover(-1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 25,
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: isGameOver || isPaused
                                    ? null
                                    : () => _mover(1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTapDown: isGameOver || isPaused
                                ? null
                                : (_) => onStartDrop(),
                            onTapUp: isGameOver || isPaused
                                ? null
                                : (_) => onEndDrop(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: isGameOver || isPaused ? null : _drop,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.circle_outlined,
                          size: 80,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(5),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  _resetor() {
    setState(() {
      timer?.cancel();
      isPaused = false;
      isGameOver = false;
      score = 0;
      block.clear();
      nextBlock
        ..clear()
        ..addAll(
            Constants.blockList[Random().nextInt(Constants.blockList.length)]);
      blockSpace
        ..clear()
        ..addAll(
          List.generate(
            25,
            (index) => List.generate(
              10,
              (index) => 0,
            ),
          ),
        );
      globalKeys
        ..clear()
        ..addAll(
          List.generate(
            25,
            (indexY) => List.generate(
              10,
              (indexX) => GlobalKey(debugLabel: '${indexY.alphabet}$indexX'),
            ),
          ),
        );
      positioned = null;
      GlobalIndex(0, 0);
    });
  }

  _pauser() {
    if (isPaused) {
      timer = _dropper();
    } else {
      timer?.cancel();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  _spawner() {
    final List<List<int>> _block = List.from(nextBlock);
    nextBlock
      ..clear()
      ..addAll(
        Constants.blockList[Random().nextInt(Constants.blockList.length)],
      );
    final indexX =
        ((blockSpace.first.length / 2) - (_block.first.length / 2)).toInt();
    setState(() {
      globalIndex
        ..indexX = indexX
        ..indexY = 0;
      positioned = (globalKeys[globalIndex.indexY][globalIndex.indexX]
              .currentContext!
              .findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
      block
        ..clear()
        ..addAll(_block);
    });
    timer?.cancel();
    timer = _dropper();
  }

  Timer _dropper() {
    return Timer.periodic(Duration(milliseconds: 400), (_) {
      _dropBlock(_.cancel, true);
    });
  }

  void onStartDrop() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      _dropBlock(_.cancel, true);
    });
  }

  void onEndDrop() {
    timer?.cancel();
    timer = _dropper();
  }

  void _drop() {
    timer?.cancel();
    bool stop = false;

    while (!stop) {
      _dropBlock(() => stop = true);
    }
  }

  void _dropBlock([VoidCallback? onStop, shouldRender = false]) {
    if (!block.last.contains(1)) {
      block.removeLast();
    }

    final bool needBreak = _posibleGoDown();
    if (needBreak) {
      globalIndex.indexY++;
    } else {
      onStop?.call();
      List<List<int>> newSpace = joinBelow(blockSpace, block, null, 1);
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

      _spawner();
    }
    if (shouldRender) {
      setState(() {});
    }
  }

  bool _possibleMove(int indexX) {
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

  _mover(int indexX) {
    if (indexX.isNegative &&
        !(globalIndex.indexX - 1).isNegative &&
        _possibleMove(indexX)) {
      setState(() {
        globalIndex.indexX--;
      });
    } else if (!indexX.isNegative &&
        (globalIndex.indexX + 1) <=
            blockSpace.first.length - block.first.length &&
        _possibleMove(indexX)) {
      setState(() {
        globalIndex.indexX++;
      });
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

  List<List<int>> joinBelow(List<List<int>> space, List<List<int>> block,
      [VoidCallback? onBreak, int extraY = 0]) {
    final List<List<int>> duplicateSpace =
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

  _rotator() {
    final backupedBlock =
        List.generate(block.length, (index) => List<int>.from(block[index]));

    try {
      final List<List<int>> newBlock = [];
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
      _rotator();
    }
    setState(() {});
  }
}
