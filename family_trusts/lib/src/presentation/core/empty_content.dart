import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final double size;

  const EmptyContent({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyText(
            LocaleKeys.global_noContent.tr(),
            fontSize: size,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
