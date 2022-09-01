import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/profile/trusted_users/trusted_user_form/widgets/trusted_user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrustedUserForm extends StatelessWidget with LogMixin {
  final User connectedUser;

  const TrustedUserForm({
    Key? key,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileTabBloc>().add(const ProfileTabEvent.gotoTrustedUsers());
    return BlocConsumer<TrustedUserFormBloc, TrustedUserFormState>(
      listener: (context, state) {
        switch (state.state) {
          case TrustedUserFormStateEnum.none:
            break;
          case TrustedUserFormStateEnum.adding:
            showProgressMessage(
              LocaleKeys.profile_addTrustedUserInProgress.tr(),
              context,
            );
            break;
          case TrustedUserFormStateEnum.searching:
            showProgressMessage(
              "Recherche en cours",
              context,
            );
            break;
        }

        state.searchUserFailureOrSuccessOption.fold(
          () => null,
          (result) {
            result.fold(
              (failure) {
                showErrorMessage(LocaleKeys.global_unexpected.tr(), context);
              },
              (_) => null,
            );
          },
        );

        state.addTrustedUserFailureOrSuccessOption.fold(
          () => null,
          (result) {
            result.fold((failure) {
              showErrorMessage(
                failure.map(
                  unexpected: (_) => LocaleKeys.global_unexpected.tr(),
                  insufficientPermission: (_) =>
                      LocaleKeys.global_insufficientPermission.tr(),
                  unableToAddTrustedUser: (_) =>
                      LocaleKeys.profile_addLocationFailure.tr(),
                ),
                context,
              );
            }, (success) {
              showSuccessMessage(
                LocaleKeys.profile_addTrustedUserSuccess.tr(),
                context,
                //duration: const Duration(seconds: 20),
                onDismissed: () => AutoRouter.of(context).pop(),
              );
            });
          },
        );

        /*

        state.maybeMap(
          usersNotLoaded: (s) {
            showErrorMessage(LocaleKeys.global_serverError.tr(), context);
          },
          addTrustedUserFailure: (s) {
            showErrorMessage(
                LocaleKeys.profile_addTrustedUserFailure.tr(), context);
          },
          deleteTrustedUserFailure: (s) {
            showErrorMessage(
                LocaleKeys.profile_deleteTrustedUserFailure.tr(), context);
          },
          addTrustedUserInProgress: (s) {
            showProgressMessage(LocaleKeys.profile_addTrustedUserInProgress.tr(), context);
          },
          addTrustedUserSuccess: (s) {
            showSuccessMessage(
              LocaleKeys.profile_addTrustedUserSuccess.tr(),
              context,
              //duration: const Duration(seconds: 20),
              onDismissed: () => AutoRouter.of(context).pop(),
            );
          },
          deleteTrustedUserInProgress: (s) {
            showProgressMessage(
                LocaleKeys.profile_deleteTrustedUserInProgress.tr(), context);
          },
          deleteTrustedUserSuccess: (s) {
            showSuccessMessage(
                LocaleKeys.profile_deleteTrustedUserSuccess.tr(), context);
          },
          orElse: () {},
        );

         */
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              userLookupText(context),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              buildResult(state, context),
            ],
          ),
        );
      },
    );
  }

  Widget userLookupText(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.search_userLookupText.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context.read<TrustedUserFormBloc>().add(
            TrustedUserFormEvent.userLookupChanged(
              userLookupText: value,
              currentUser: connectedUser,
            ),
          ),
    );
  }

  Widget buildResult(TrustedUserFormState state, BuildContext context) {
    switch (state.state) {
      case TrustedUserFormStateEnum.searching:
        return const CircularProgressIndicator();
      case TrustedUserFormStateEnum.adding:
        return const CircularProgressIndicator();
      default:
        return state.searchUserFailureOrSuccessOption.fold(
          () => const EmptyContent(),
          (s) => s.fold(
            (failure) => Center(
              child: MyText(LocaleKeys.global_serverError.tr()),
            ),
            (users) => Expanded(
              child: users.isEmpty
                  ? const EmptyContent()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final User selectedUser = users[index];
                        return InkWell(
                          onTap: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.profile_sendTrustProposal
                                  .tr(args: [selectedUser.displayName]),
                              onConfirmCallback: () {
                                context.read<TrustedUserFormBloc>().add(
                                      TrustedUserFormEvent.addTrustedUser(
                                        currentUser: connectedUser,
                                        userToAdd: selectedUser,
                                        time: TimestampVo.now(),
                                      ),
                                    );
                              },
                            );
                          },
                          child: TrustedUserCard(user: selectedUser),
                        );
                      },
                      itemCount: users.length,
                    ),
            ),
          ),
        );
    }
  }
}
