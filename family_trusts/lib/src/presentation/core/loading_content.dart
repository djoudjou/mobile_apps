import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';

class LoadingContent extends StatelessWidget {

  const LoadingContent({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyText(
            LocaleKeys.global_loading.tr(),
            fontSize: 20.0,
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
