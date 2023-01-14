import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAppBar extends SliverAppBar {
  ProfileAppBar(
    TabBar? tabBar, {super.key,
    required BuildContext context,
    required User currentUser,
    User? spouse,
    required double radius,
    required bool innerBoxIsScrolled,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          floating: true,
          forceElevated: innerBoxIsScrolled,
          bottom: tabBar,
          actions: <Widget>[
            IconButton(
              color: Colors.black,
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
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: tabBar != null
                ? const EdgeInsets.only(bottom: 75)
                : const EdgeInsets.only(bottom: 20),
            title: MyText(currentUser.displayName),
            background: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: const DecorationImage(
                  image: profileImages,
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyAvatar(
                      imageTag: "TAG_PROFILE_${currentUser.id}",
                      photoUrl: currentUser.photoUrl,
                      radius: radius,
                      onTapCallback: () => gotoEditUserScreen(
                        user: currentUser,
                        currentUser: currentUser,
                        context: context,
                      ),
                      defaultImage: defaultUserImages,
                    ),
                    if (spouse != null) ...[
                      const MyHorizontalSeparator(),
                      const MyHorizontalSeparator(),
                      MyAvatar(
                        imageTag: "TAG_PROFILE_${spouse.id}",
                        photoUrl: spouse.photoUrl,
                        radius: radius,
                        onTapCallback: () => gotoEditUserScreen(
                          user: spouse,
                          currentUser: currentUser,
                          context: context,
                        ),
                        defaultImage: defaultUserImages,
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
}
