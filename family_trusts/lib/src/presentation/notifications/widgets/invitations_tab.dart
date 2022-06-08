import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/application/notifications/notifications_invitations/bloc.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/invitation/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationsTab extends StatelessWidget {
  final User connectedUser;
  final _key = const PageStorageKey<String>('invitations');

  InvitationsTab({Key? key, required this.connectedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsInvitationsBloc>(
      create: (context) => getIt<NotificationsInvitationsBloc>()
        ..add(SimpleLoaderEvent.startLoading(connectedUser.id)),
      child: BlocConsumer<NotificationsInvitationsBloc, SimpleLoaderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.maybeMap(
            simpleErrorEventState: (simpleErrorEventState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    ErrorContent(),
                  ],
                ),
              );
            },
            simpleSuccessEventState: (simpleSuccessEventState) {
              final List<Either<InvitationFailure, Invitation>>
                  invitationsResult = simpleSuccessEventState.items
                      as List<Either<InvitationFailure, Invitation>>;

              final invitations = invitationsResult
                  .where((element) => element.isRight())
                  .map((e) => e.toOption().toNullable()!)
                  .toList();

              if (invitations.isEmpty) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: MyText(
                      LocaleKeys.invitations_empty.tr(),
                      style: FontStyle.italic,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  key: _key,
                  padding: const EdgeInsets.all(8),
                  itemCount: invitations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final invitation = invitations[index];
                    return Card(
                      elevation: 10.0,
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 30,
                                //color: Colors.red,
                                child: MyText(
                                  invitation.date.toPrintableDate,
                                  alignment: TextAlign.start,
                                ),
                              ),
                            ),
                            Expanded(
                              child: MyText(
                                formatMessage(invitation),
                                maxLines: 5,
                                style: FontStyle.italic,
                                //alignment: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      await AlertHelper().confirm(
                                        context,
                                        LocaleKeys.invitations_confirm.tr(),
                                        onConfirmCallback: () {
                                          context.read<SetupFamilyBloc>().add(
                                                SetupFamilyEvent
                                                    .acceptInvitationTriggered(
                                                  invitation: invitation,
                                                ),
                                              );
                                        },
                                      );
                                    },
                                    child: MyText(
                                      LocaleKeys.invitations_accept.tr(),
                                      color: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await AlertHelper().confirm(
                                        context,
                                        LocaleKeys.invitations_confirm.tr(),
                                        onConfirmCallback: () {
                                          BlocProvider.of<SetupFamilyBloc>(
                                            context,
                                          ).add(
                                            SetupFamilyEvent
                                                .declineInvitationTriggered(
                                              invitation: invitation,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: MyText(
                                      LocaleKeys.invitations_decline.tr(),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              }
            },
            orElse: () {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LoadingContent(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatMessage(Invitation invitation) {
    String msg = "";
    final String from = invitation.from.displayName;

    switch (invitation.type.getOrCrash()) {
      case InvitationTypeEnum.spouse:
        msg = LocaleKeys.invitations_spouse_confirm.tr(args: [from]);
        break;
      case InvitationTypeEnum.trust:
        msg = LocaleKeys.invitations_trust_confirm.tr(args: [from]);
        break;
    }

    return msg;
  }
}
