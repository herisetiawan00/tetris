import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/common/block_builder.dart';
import 'package:tetr/journey/common/entities/button_callback_entity.dart';
import 'package:tetr/journey/common/extensions/context_extensions.dart';
import 'package:tetr/journey/console_wrapper.dart/console_wrapper.dart';
import 'package:tetr/journey/console_wrapper.dart/side_item_builder.dart';
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

  @override
  void dispose() {
    utils.timer?.cancel();
    super.dispose();
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

    return ConsoleWrapper(
      onStackWidget: [
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  utils.isGameOver ? 'Game Over' : 'Paused',
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
      sideWidgets: [
        SideItemBuilder(
          padding: EdgeInsets.symmetric(vertical: 8),
          title: 'Next:',
          value: Container(
            width: 48.0,
            child: BlockBuilder(
              block: utils.nextBlock,
              size: 12,
              emptyColor: context.theme.accentColor,
            ),
          ),
        ),
        SideItemBuilder(
          padding: EdgeInsets.symmetric(vertical: 8),
          title: 'Score:',
          value: Text(
            '${utils.score}',
            style: TextStyle(
              color: Color(0xff0f380f),
              fontSize: 10,
            ),
          ),
        ),
        SideItemBuilder(
          padding: EdgeInsets.symmetric(vertical: 8),
          title: 'High:',
          value: Text(
            '${utils.highscore}',
            style: TextStyle(
              color: Color(0xff0f380f),
              fontSize: 10,
            ),
          ),
        ),
      ],
      onUp: ButtonCallbackEntity(
        onTap: utils.isGameOver || utils.isPaused ? null : utils.rotator,
      ),
      onDown: ButtonCallbackEntity(
        onTapDown: utils.isGameOver || utils.isPaused
            ? null
            : (_) => utils.onStartDrop(),
        onTapUp: utils.isGameOver || utils.isPaused
            ? null
            : (_) => utils.onEndDrop(),
      ),
      onLeft: ButtonCallbackEntity(
        onTap:
            utils.isGameOver || utils.isPaused ? null : () => utils.mover(-1),
      ),
      onRight: ButtonCallbackEntity(
        onTap: utils.isGameOver || utils.isPaused ? null : () => utils.mover(1),
      ),
      onPause: ButtonCallbackEntity(
        onTap: utils.isGameOver ? null : utils.pauser,
      ),
      onRetry: ButtonCallbackEntity(
        onTap: utils.resetor,
      ),
      onAction: ButtonCallbackEntity(
        onTap: utils.isGameOver || utils.isPaused ? null : utils.drop,
      ),
      onBack: ButtonCallbackEntity(
        onTap: Navigator.of(context).pop,
      ),
    );
  }
}
