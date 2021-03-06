import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppBar extends AppBar {
  final String pageTitle;
  final BuildContext context;
  final bool displayLogout;

  MyAppBar({
    this.displayLogout = true,
    required this.context,
    required this.pageTitle,
    PreferredSizeWidget? bottom,
  }) : super(
          title: MyText(
            pageTitle,
            color: Colors.white,
            fontSize: 20,
          ),
          bottom: bottom,
          actions: <Widget>[
            if (displayLogout) ...[
              IconButton(
                //color: Colors.black54,
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  AlertHelper().confirm(
                    context,
                    LocaleKeys.logout_confirm.tr(),
                    onConfirmCallback: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(const AuthenticationEvent.signedOut());
                    },
                  );
                },
              )
            ]
          ],
        );
}

class MySilverAppBar extends SliverAppBar {
  MySilverAppBar({
    Key? key,
    required String pageTitle,
    AssetImage? image,
    double height = 150.0,
    required PreferredSizeWidget bottom,
    required BuildContext context,
  }) : super(
          key: key,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: MyText(pageTitle, color: Colors.white),
            background: image != null
                ? Image(
                    image: image,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          expandedHeight: height,
          bottom: bottom,
          actions: <Widget>[
            IconButton(
              //color: Colors.black54,
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                AlertHelper().confirm(
                  context,
                  LocaleKeys.logout.tr(),
                  onConfirmCallback: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(const AuthenticationEvent.signedOut());
                  },
                );
              },
            )
          ],
        );
}
