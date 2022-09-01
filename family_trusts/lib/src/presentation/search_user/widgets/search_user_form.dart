import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/search_user/bloc.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/search_user/widgets/search_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserForm extends StatelessWidget {
  final User connectedUser;
  final bool lookingForNewTrustUser;

  const SearchUserForm({
    Key? key,
    required this.connectedUser,
    required this.lookingForNewTrustUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchUserBloc, SearchUserState>(
      listener: (context, state) {
        state.searchUserFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(
                failure.map(
                  serverError: (_) => LocaleKeys.global_serverError.tr(),
                ),
                context,
              );
            },
            (_) {},
          ),
        );
      },
      child: BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                userLookupText(context),
                const SizedBox(height: 8),
                buildResult(state, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget userLookupText(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.search_userLookupText.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context
          .read<SearchUserBloc>()
          .add(SearchUserEvent.userLookupChanged(value)),
    );
  }

  Widget buildResult(SearchUserState state, BuildContext context) {
    if (state.isSubmitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return state.searchUserFailureOrSuccessOption.fold(
        () => Container(),
        (searchUserFailureOrSuccess) => searchUserFailureOrSuccess.fold(
          (searchUserFailure) => Center(
            child: MyText(LocaleKeys.global_serverError.tr()),
          ),
          (users) {
            if (users.isEmpty) {
              return const EmptyContent();
            } else {
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final User selectedUser = users[index];
                    return InkWell(
                      onTap: () async {
                        await AlertHelper().confirm(
                          context,
                          LocaleKeys.profile_sendTrustProposal
                              .tr(args: [selectedUser.displayName]),
                          onConfirmCallback: () {
                            //context.read<TrustedUserWatcherBloc>().add(
                            //  TrustedUserWatcherEvent.addTrustedUser(
                            //    currentUser: connectedUser,
                            //    userToAdd: selectedUser,
                            //  ),
                            //);
                            AutoRouter.of(context).pop();
                          },
                        );
                      },
                      child: SearchUserCard(user: selectedUser),
                    );
                  },
                  itemCount: users.length,
                ),
              );
            }
          },
        ),
      );
    }
  }
}
