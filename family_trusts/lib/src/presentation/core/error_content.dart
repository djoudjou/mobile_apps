import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class ErrorContent extends StatelessWidget {
  final double size;

  const ErrorContent({super.key, this.size = 40.0});

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
