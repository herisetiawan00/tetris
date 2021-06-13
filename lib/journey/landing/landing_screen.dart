import 'package:flutter/material.dart';
import 'package:tetr/journey/common/constants.dart';
import 'package:tetr/journey/common/entities/button_callback_entity.dart';
import 'package:tetr/journey/console_wrapper.dart/console_wrapper.dart';
import 'package:tetr/journey/console_wrapper.dart/side_item_builder.dart';
import 'package:tetr/journey/routes.dart';
import 'package:tetr/journey/tetris/tetris_preview.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String? currentGame;
  String gameId = '';

  Map<String, Widget> get gameList => {
        RouteList.tetris: TetrisPreview(
          setStackWidget: (widgets) => stackWidget = widgets,
        ),
        'coming': Text(
          'Coming\nSoon',
          textAlign: TextAlign.center,
        ),
      };

  final List<Widget> stackWidget = [];

  set stackWidget(List<Widget> widgets) {
    stackWidget
      ..clear()
      ..addAll(widgets);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    currentGame ??= gameList.keys.first;
    return ConsoleWrapper(
      onStackWidget: stackWidget,
      sideWidgets: [
        SideItemBuilder(
          title: 'High',
          value: Text(
            '99999',
            style: TextStyle(
              color: Color(0xff0f380f),
              fontSize: 10,
            ),
          ),
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_rounded),
                  Text(currentGame?.replaceFirst('/', '') ?? ''),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          ),
          Spacer(),
          gameList[currentGame] ?? Container(),
          Spacer(),
        ],
      ),
      onRight: ButtonCallbackEntity(onTap: () {
        stackWidget.clear();
        setState(() {
          currentGame = 'coming';
        });
      }),
      onLeft: ButtonCallbackEntity(onTap: () {
        setState(() {
          currentGame = RouteList.tetris;
        });
      }),
      onAction: ButtonCallbackEntity(
        onTap: currentGame == 'coming'
            ? null
            : () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Routes.getAll[currentGame]!(_),
                    transitionDuration: Duration(seconds: 0),
                  ),
                ),
        // Navigator.of(context).pushReplacementNamed('/$currentGame'),
      ),
    );
  }
}
