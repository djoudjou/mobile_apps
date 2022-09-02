import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_bloc.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_event.dart';
import 'package:familytrusts/src/application/join_proposal/issuer_join_proposal_bloc.dart';
import 'package:familytrusts/src/application/join_proposal/issuer_join_proposal_event.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinFamilyProposalWidget extends StatelessWidget {
  const JoinFamilyProposalWidget({
    Key? key,
    required this.cardWidth,
    required this.joinProposal,
    required this.asIssuer,
    required this.asFamily,
    required this.connectedUser,
  }) : super(key: key);

  final double cardWidth;
  final JoinProposal joinProposal;
  final bool asIssuer;
  final bool asFamily;
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String message;

    switch (joinProposal.state!.getOrCrash()) {
      case JoinProposalStateEnum.accepted:
        message = LocaleKeys.join_proposal_details_accepted_text.tr();
        badgeColor = Theme.of(context).accentColor;
        break;
      case JoinProposalStateEnum.canceled:
        badgeColor = Theme.of(context).primaryColorLight;
        message = LocaleKeys.join_proposal_details_canceled_text.tr();
        break;
      case JoinProposalStateEnum.waiting:
        message = LocaleKeys.join_proposal_details_waiting_text.tr();
        badgeColor = Theme.of(context).primaryColor;
        break;
      case JoinProposalStateEnum.declined:
        badgeColor = Theme.of(context).primaryColorLight;
        message = LocaleKeys.join_proposal_details_declined_text.tr();
        break;
      case JoinProposalStateEnum.rejected:
        badgeColor = Theme.of(context).primaryColorLight;
        message = LocaleKeys.join_proposal_details_rejected_text.tr();
        break;
    }

    return Container(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (asFamily) ...[
                  Column(
                    children: [
                      MyAvatar(
                        imageTag: "TAG_PROFILE_${joinProposal.issuer?.id}",
                        photoUrl: joinProposal.issuer?.photoUrl,
                        radius: 40,
                        defaultImage: defaultUserImages,
                        onTapCallback: () {},
                      ),
                      MyText(joinProposal.issuer!.displayName),
                    ],
                  ),
                ],
                if (asIssuer) ...[
                  MyAvatar(
                    defaultImage: logoFamilyImages,
                    onTapCallback: () {},
                    radius: 60,
                    imageTag: "JOIN_PROPOSAL_${joinProposal.id ?? "XX"}",
                  ),
                ],
                const MyHorizontalSeparator(),
                Container(
                  //color: Colors.red,
                  //width: MediaQuery.of(context).size.width/3,
                  child: Column(
                    children: [
                      if (asIssuer) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              LocaleKeys.join_proposal_details_family_label.tr(),
                            ),
                            const MyText(" : "),
                            const MyHorizontalSeparator(),
                            MyText(
                              joinProposal.family!.displayName,
                              style: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            LocaleKeys.join_proposal_details_creation_date_label
                                .tr(),
                          ),
                          const MyText(" : "),
                          const MyHorizontalSeparator(),
                          MyText(
                            joinProposal.creationDate.toPrintableDate,
                            style: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            LocaleKeys
                                .join_proposal_details_expiration_date_label
                                .tr(),
                          ),
                          const MyText(" : "),
                          const MyHorizontalSeparator(),
                          MyText(
                            joinProposal.expirationDate.toPrintableDate,
                            style: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      if (asIssuer) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              LocaleKeys.join_proposal_details_status_label.tr(),
                            ),
                            const MyText(" : "),
                            const MyHorizontalSeparator(),
                            MyText(
                              message,
                              style: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MyHorizontalSeparator(),
                          MyText(
                            joinProposal.lastUpdateDate.toPrintableDate,
                            style: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (joinProposal.member != null) ...[
              MyAvatar(
                imageTag:
                    "TAG_JP_${joinProposal.id}_${joinProposal.member?.id}",
                photoUrl: joinProposal.member?.photoUrl,
                radius: 60,
                onTapCallback: () {},
                defaultImage: defaultUserImages,
              ),
            ],
            if (asIssuer) ...[
              MyButton(
                message: LocaleKeys.join_proposal_cancel_button.tr(),
                onPressed: () async {
                  await AlertHelper().confirm(
                    context,
                    LocaleKeys.join_proposal_cancel_confirm
                        .tr(args: [joinProposal.family!.displayName]),
                    onConfirmCallback: () {
                      BlocProvider.of<IssuerJoinProposalBloc>(
                        context,
                      ).add(
                        IssuerJoinProposalEvent.cancel(
                          connectedUser: connectedUser,
                          joinProposal: joinProposal,
                        ),
                      );
                    },
                  );
                },
              )
            ],
            if (asFamily) ...[
              MyButton(
                message: LocaleKeys.join_proposal_accept_button.tr(),
                onPressed: () async {
                  await AlertHelper().confirm(
                    context,
                    LocaleKeys.join_proposal_accept_confirm
                        .tr(args: [joinProposal.issuer!.displayName]),
                    onConfirmCallback: () {
                      BlocProvider.of<FamilyJoinProposalBloc>(
                        context,
                      ).add(
                        FamilyJoinProposalEvent.accept(
                          connectedUser: connectedUser,
                          joinProposal: joinProposal,
                        ),
                      );
                    },
                  );
                },
              ),
              MyButton(
                message: LocaleKeys.join_proposal_decline_button.tr(),
                onPressed: () async {
                  await AlertHelper().confirm(
                    context,
                    LocaleKeys.join_proposal_decline_confirm
                        .tr(args: [joinProposal.issuer!.displayName]),
                    onConfirmCallback: () {
                      BlocProvider.of<FamilyJoinProposalBloc>(
                        context,
                      ).add(
                        FamilyJoinProposalEvent.decline(
                          connectedUser: connectedUser,
                          joinProposal: joinProposal,
                        ),
                      );
                    },
                  );
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}
