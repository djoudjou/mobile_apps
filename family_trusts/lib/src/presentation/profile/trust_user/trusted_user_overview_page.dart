import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTrustedUsers extends StatelessWidget {
  final double radius;
  final User connectedUser;
  static const _key = PageStorageKey<String>('trusted');

  const ProfileTrustedUsers({
    super.key,
    required this.radius,
    required this.connectedUser,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) =>
          BlocConsumer<TrustedUserWatcherBloc, TrustedUserWatcherState>(
        listener: (context, state) {
          state.map(
            trustedUsersLoading: (_) {},
            trustedUsersLoaded: (_) {},
            trustedUsersNotLoaded: (_) => showErrorMessage(
              LocaleKeys.profile_trustedUsersNotLoaded.tr(),
              context,
            ),
          );
        },
        builder: (trustedUserWatcherBlocContext, state) {
          return state.maybeMap(
            orElse: () => Column(
              children: <Widget>[
                MyText(LocaleKeys.profile_tabs_trusted_loading.tr()),
                const LoadingContent(),
              ],
            ),
            trustedUsersNotLoaded: (trustedUsersNotLoaded) => ColoredBox(
              color: Colors.blue,
              child: MyText(LocaleKeys.profile_tabs_trusted_error.tr()),
            ),
            trustedUsersLoaded: (trustedUsersLoaded) =>
                trustedUsersLoaded.eitherTrustedUsers.fold(
              (userFailure) => const ErrorContent(),
              (trustedUsers) => trustedUsers.isEmpty
                  ? Align(
                      child: MyText(
                        LocaleKeys.profile_tabs_trusted_noTrusted.tr(),
                        maxLines: 3,
                      ),
                    )
                  : ListView.separated(
                      key: _key,
                      padding: const EdgeInsets.all(8),
                      itemCount: trustedUsers.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final trustedUser = trustedUsers[index];
                        return Container(
                          //color: Colors.red,
                          //height: 100,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: MyAvatar(
                                  imageTag:
                                      "TAG_TRUSTED_${trustedUser.id}",
                                  photoUrl: trustedUser.photoUrl,
                                  radius: radius / 2,
                                  onTapCallback: () => gotoEditTrustUserScreen(
                                    imageTag: "TAG_TRUSTED_${trustedUser.id}",
                                    trustedUser: trustedUser,
                                    currentUser: connectedUser,
                                    context: trustedUserWatcherBlocContext,
                                  ),
                                  defaultImage: defaultUserImages,
                                ),
                              ),
                              const MyHorizontalSeparator(),
                              InkWell(
                                onTap: () => gotoEditTrustUserScreen(
                                  imageTag: "TAG_TRUSTED_${trustedUser.id}",
                                  trustedUser: trustedUser,
                                  currentUser: connectedUser,
                                  context: trustedUserWatcherBlocContext,
                                ),
                                child: MyText(
                                  trustedUser.displayName,
                                  alignment: TextAlign.start,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
