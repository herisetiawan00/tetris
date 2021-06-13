import 'package:flutter/material.dart';
import 'package:tetr/configurations.dart';
import 'package:tetr/journey/common/entities/button_callback_entity.dart';
import 'package:tetr/journey/common/extensions/context_extensions.dart';
import 'package:tetr/journey/console_wrapper.dart/console_button.dart';

class ConsoleWrapper extends StatelessWidget {
  final Widget child;
  final List<Widget> sideWidgets;
  final List<Widget>? onStackWidget;
  final ButtonCallbackEntity? onUp;
  final ButtonCallbackEntity? onDown;
  final ButtonCallbackEntity? onRight;
  final ButtonCallbackEntity? onLeft;
  final ButtonCallbackEntity? onPause;
  final ButtonCallbackEntity? onRetry;
  final ButtonCallbackEntity? onAction;

  const ConsoleWrapper({
    Key? key,
    required this.sideWidgets,
    required this.child,
    this.onStackWidget,
    this.onUp,
    this.onDown,
    this.onRight,
    this.onLeft,
    this.onPause,
    this.onRetry,
    this.onAction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Configurations.consolePrimaryColor,
        child: Column(
          children: [
            Stack(
              children: [
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
                                  Configurations.spaceSize.width,
                              height: Configurations.blockWidth *
                                  Configurations.spaceSize.height,
                              child: child,
                            ),
                            Container(
                              height: Configurations.blockWidth *
                                  Configurations.spaceSize.height,
                              width: 2,
                              child: VerticalDivider(
                                thickness: 2,
                                color: Color(0xff0f380f),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 65,
                                child: Column(
                                  children: sideWidgets,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ...?onStackWidget,
              ],
            ),
            Spacer(),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConsoleButton(
                      padding: const EdgeInsets.all(8.0),
                      callback: onPause,
                      icon: Icons.pause,
                      size: 10,
                      iconColor: Configurations.consoleIconColor,
                      color: Configurations.consoleSecondaryColor,
                    ),
                    ConsoleButton(
                      padding: const EdgeInsets.all(8.0),
                      callback: onRetry,
                      icon: Icons.refresh,
                      size: 10,
                      iconColor: Configurations.consoleIconColor,
                      color: Configurations.consoleSecondaryColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        ConsoleButton(
                          padding: const EdgeInsets.all(8.0),
                          callback: onUp,
                          icon: Icons.arrow_upward_rounded,
                          size: 25,
                          iconColor: Configurations.consoleIconColor,
                          color: Configurations.consoleSecondaryColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConsoleButton(
                              padding: const EdgeInsets.all(8.0),
                              callback: onLeft,
                              icon: Icons.arrow_back_rounded,
                              size: 25,
                              iconColor: Configurations.consoleIconColor,
                              color: Configurations.consoleSecondaryColor,
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 25,
                              height: 25,
                            ),
                            ConsoleButton(
                              padding: const EdgeInsets.all(8.0),
                              callback: onRight,
                              icon: Icons.arrow_forward_rounded,
                              size: 25,
                              iconColor: Configurations.consoleIconColor,
                              color: Configurations.consoleSecondaryColor,
                            ),
                          ],
                        ),
                        ConsoleButton(
                          padding: const EdgeInsets.all(8.0),
                          callback: onDown,
                          icon: Icons.arrow_downward_rounded,
                          size: 25,
                          iconColor: Configurations.consoleIconColor,
                          color: Configurations.consoleSecondaryColor,
                        ),
                      ],
                    ),
                    ConsoleButton(
                      callback: onAction,
                      icon: Icons.circle_outlined,
                      size: 80,
                      iconColor: Configurations.consoleIconColor,
                      color: Configurations.consoleSecondaryColor,
                    ),
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
