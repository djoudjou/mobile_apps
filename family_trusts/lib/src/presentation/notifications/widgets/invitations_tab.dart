import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:flutter/material.dart';

class InvitationsTab extends StatelessWidget {
  final User connectedUser;
  final _key = const PageStorageKey<String>('invitations');

  const InvitationsTab({Key? key, required this.connectedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyContent();
    /*BlocProvider<NotificationsInvitationsBloc>(
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
    */
  }
/*
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

 */
}
