import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';

class ErrorContent extends StatelessWidget {
  final double size;

  const ErrorContent({Key? key, this.size=40.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          MyText(
            LocaleKeys.global_serverError.tr(),
            fontSize: size,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
