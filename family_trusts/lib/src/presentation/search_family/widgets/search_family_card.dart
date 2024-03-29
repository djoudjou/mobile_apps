import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';

class SearchFamilyCard extends StatelessWidget {
  final Family family;

  const SearchFamilyCard({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 12.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const MyVerticalSeparator(),
                  MyText(family.displayName),
                  MyButton(
                    onPressed: () async {
                      AutoRouter.of(context).pop(family);
                    },
                    message: LocaleKeys.join_proposal_send_button.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
