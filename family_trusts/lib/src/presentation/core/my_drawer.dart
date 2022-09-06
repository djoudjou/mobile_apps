import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/authentication_bloc.dart';
import 'package:familytrusts/src/application/auth/authentication_event.dart';
import 'package:familytrusts/src/application/home/tab/tab_bloc.dart';
import 'package:familytrusts/src/application/home/tab/tab_event.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required this.user,
    this.radius = 60.0,
    this.spouse,
  }) : super(key: key);

  final User user;
  final double radius;
  final User? spouse;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: const Alignment(0.8, 0.0),
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyAvatar(
                    imageTag: "TAG_PROFILE_${user.id}",
                    photoUrl: user.photoUrl,
                    radius: radius,
                    onTapCallback: () => gotoEditUserScreen(
                      user: user,
                      currentUser: user,
                      context: context,
                    ),
                    defaultImage: defaultUserImages,
                  ),
                  if (spouse != null) ...[
                    const MyHorizontalSeparator(),
                    const MyHorizontalSeparator(),
                    MyAvatar(
                      imageTag: "TAG_PROFILE_${spouse?.id}",
                      photoUrl: spouse?.photoUrl,
                      radius: radius,
                      onTapCallback: () => gotoEditUserScreen(
                        user: spouse!,
                        currentUser: user,
                        context: context,
                      ),
                      defaultImage: defaultUserImages,
                    )
                  ]
                ],
              ),
            ),
          ),
          MyText(user.displayName),
          MyText(user.email.getOrCrash()),
          const Divider(),
          ListTile(
            onTap: () => gotoEditUserScreen(
              user: user,
              currentUser: user,
              context: context,
            ),
            leading: const Icon(Icons.account_circle),
            title: MyText(LocaleKeys.profile_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              context.read<TabBloc>().add(const TabEvent.gotoAsk());
              context.popRoute();
            },
            leading: const Icon(Icons.search),
            title: MyText(LocaleKeys.ask_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              context.read<TabBloc>().add(const TabEvent.gotoMyDemands());
              context.popRoute();
            },
            leading: const Icon(Icons.assignment),
            title: MyText(LocaleKeys.demands_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              context.read<TabBloc>().add(const TabEvent.gotoNotification());
              context.popRoute();
            },
            leading: const Icon(Icons.notifications),
            title: MyText(LocaleKeys.notifications_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              context.read<TabBloc>().add(const TabEvent.gotoMe());
              context.popRoute();
            },
            leading: const Icon(Icons.group),
            title: MyText(LocaleKeys.family_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () async {
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
            leading: const Icon(Icons.exit_to_app),
            title: MyText(LocaleKeys.logout_title.tr()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          )
        ],
      ),
    );
  }
}
