import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorMessage(
  String text,
  BuildContext context, {
  Duration duration = const Duration(seconds: 3),
  Function()? onDismissed,
}) {
  final Flushbar flushbar = Flushbar(
    message: text,
    icon: Icon(
      Icons.warning,
      size: 28.0,
      color: Colors.red[300],
    ),
    leftBarIndicatorColor: Colors.red[300],
    duration: duration,
    onStatusChanged: (FlushbarStatus? status) {
      if (status == FlushbarStatus.DISMISSED && onDismissed != null) {
        onDismissed();
      }
    },
  );
  flushbar.show(context);
}

void showSuccessMessage(
  String text,
  BuildContext context, {
  Duration duration = const Duration(seconds: 3),
  Function()? onDismissed,
}) {
  //FlushbarHelper.createSuccess(message: text).show(context);

  final Flushbar flushbar = Flushbar(
    message: text,
    icon: Icon(
      Icons.check_circle,
      color: Colors.green[300],
    ),
    leftBarIndicatorColor: Colors.green[300],
    onStatusChanged: (FlushbarStatus? status) {
      if (status == FlushbarStatus.DISMISSED && onDismissed != null) {
        onDismissed();
      }
    },
    duration: duration,
  );
  flushbar.show(context);
}

void showProgressMessage(
  String text,
  BuildContext context, {
  Duration duration = const Duration(seconds: 3),
  Function()? onDismissed,
}) {
  //FlushbarHelper.createInformation(message: text).show(context);

  final Flushbar flushbar = Flushbar(
    message: text,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue[300],
    ),
    leftBarIndicatorColor: Colors.blue[300],
    onStatusChanged: (FlushbarStatus? status) {
      if (status == FlushbarStatus.DISMISSED && onDismissed != null) {
        onDismissed();
      }
    },
    duration: duration,
  );
  flushbar.show(context);
}

/*
void showErrorMessage(String text, BuildContext context) {
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text,
              color: Colors.black,
            ),
            const Icon(Icons.error),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
}

void showSuccessMessage(String text, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text,
              color: Colors.white,
            ),
            const Icon(Icons.thumb_up),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
}

void showProgressMessage(String text, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text,
              color: Colors.white,
            ),
            const CircularProgressIndicator(),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
}

 */
