import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _message;
  final Color? backgroundColor;
  final Color? textColor;

  const MyButton({
    super.key,
    required String message,
    required VoidCallback onPressed,
    this.backgroundColor,
    this.textColor,
  })  : _onPressed = onPressed,
        _message = message;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (backgroundColor != null) {
      themeData = themeData.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: themeData.elevatedButtonTheme.style!.copyWith(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
          ),
        ),
      );
    }
    return Theme(
      data: themeData,
      child: ElevatedButton(
        //style: raisedButtonStyle,
        onPressed: _onPressed,
        child: MyText(
          _message,
          color: textColor ?? themeData.colorScheme.onPrimary,
          //color: textColor ?? themeData.accentTextTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
