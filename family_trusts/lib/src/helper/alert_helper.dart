import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnOkClickCallback = Function();

class AlertHelper {
  Future<void> confirm(
    BuildContext context,
    String title, {
    OnOkClickCallback? onConfirmCallback,
  }) async {
    final MyText titleWidget = MyText(
      title,
      color: Colors.black,
      maxLines: 3,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return (Theme.of(context).platform == TargetPlatform.iOS)
            ? CupertinoAlertDialog(
                title: titleWidget,
                actions: <Widget>[
                  _ok(context, onConfirmCallback),
                  _nok(context),
                ],
              )
            : AlertDialog(
                title: titleWidget,
                actions: <Widget>[
                  _ok(context, onConfirmCallback),
                  _nok(context),
                ],
              );
      },
    );
  }

  TextButton _ok(BuildContext ctx, OnOkClickCallback? callback) {
    return TextButton(
      style: flatButtonStyle,
      //color: ,
      onPressed: () {
        AutoRouter.of(ctx).pop();
        callback!.call();
      },
      child: MyText(LocaleKeys.global_yes.tr(), color: Colors.red),
    );
  }

  TextButton _nok(BuildContext ctx) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        AutoRouter.of(ctx).pop();
      },
      child: MyText(LocaleKeys.global_no.tr()),
    );
  }
}
