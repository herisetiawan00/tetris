import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/common/block_builder.dart';
import 'package:tetr/journey/common/extensions/context_extensions.dart';
import 'package:tetr/journey/tetris/tetris_utils.dart';

class TetrisScreen extends StatefulWidget {
  @override
  _TetrisScreenState createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  TetrisUtils utils = TetrisUtils();

  @override
  void initState() {
    utils..requestRender = requestRender;
    utils..resetor();
    super.initState();
  }

  void requestRender() => setState(() {});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final keyPosition = utils.globalPosition;
      if (utils.positioned != keyPosition) {
        setState(() {
          if (utils.positioned == null) {
            utils.spawner();
          }
          utils.positioned = keyPosition;
        });
      }
    });

    utils.checkIsGameOver();
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
                      padding:
                          EdgeInsets.only(top: context.screenSize.width * 0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.backgroundColor,
                          border: Border.all(
                            width: Configurations.consoleFrameWidth,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                Configurations.consoleFrameWidth),
                            bottomRight: Radius.circular(
                                Configurations.consoleFrameWidth),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: Configurations.blockWidth *
                                  utils.blockSpace.first.length,
                              height: Configurations.blockWidth *
                                  utils.blockSpace.length,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: utils.isGameOver || utils.isPaused
                                        ? Configurations.opacityDisable
                                        : Configurations.opacityEnable,
                                    child: BlockBuilder(
                                      block: utils.blockSpace,
                                      keys: utils.globalKeys,
                                      size: Configurations.blockWidth,
                                    ),
                                  ),
                                  Visibility(
                                    visible: utils.isGameOver || utils.isPaused,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          utils.isGameOver
                                              ? 'Game Over'
                                              : 'Paused',
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
                                    child: BlockBuilder(
                                      block: utils.nextBlock,
                                      size: 12,
                                      emptyColor: context.theme.accentColor,
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
                                    '${utils.score}',
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
                                    '${utils.highscore}',
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
                  top: utils.positioned?.dy,
                  left: utils.positioned?.dx,
                  child: utils.block.isEmpty
                      ? Container()
                      : BlockBuilder(
                          block: utils.block,
                          size: Configurations.blockWidth,
                          opacity: utils.isPaused
                              ? Configurations.opacityDisable
                              : Configurations.opacityEnable,
                          emptyColor: Colors.transparent,
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
                        onTap: utils.isGameOver ? null : utils.pauser,
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
                        onTap: utils.resetor,
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
                            onTap: utils.isGameOver || utils.isPaused
                                ? null
                                : utils.rotator,
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
                                onTap: utils.isGameOver || utils.isPaused
                                    ? null
                                    : () => utils.mover(-1),
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
                                onTap: utils.isGameOver || utils.isPaused
                                    ? null
                                    : () => utils.mover(1),
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
                            onTapDown: utils.isGameOver || utils.isPaused
                                ? null
                                : (_) => utils.onStartDrop(),
                            onTapUp: utils.isGameOver || utils.isPaused
                                ? null
                                : (_) => utils.onEndDrop(),
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
                      onTap: utils.isGameOver || utils.isPaused
                          ? null
                          : utils.drop,
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
}
