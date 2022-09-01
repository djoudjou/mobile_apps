import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/application/join_proposal/join_proposal_bloc.dart';
import 'package:familytrusts/src/application/join_proposal/join_proposal_event.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_dto.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart' as quiver;

class JoinFamilyProposalWidget extends StatelessWidget {
  const JoinFamilyProposalWidget({
    Key? key,
    required this.cardWidth,
    required this.joinProposal,
    required this.displayCancelButton,
    required this.connectedUser,
  }) : super(key: key);

  final double cardWidth;
  final JoinProposal joinProposal;
  final bool displayCancelButton;
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String message;

    switch (joinProposal.state!.getOrCrash()) {
      case JoinProposalStateEnum.accepted:
        message = LocaleKeys.join_proposal_details_accepted_text.tr();
        badgeColor = Theme
            .of(context)
            .accentColor;
        break;
      case JoinProposalStateEnum.canceled:
        badgeColor = Theme
            .of(context)
            .primaryColorLight;
        message = LocaleKeys.join_proposal_details_canceled_text.tr();
        break;
      case JoinProposalStateEnum.waiting:
        message = LocaleKeys.join_proposal_details_waiting_text.tr();
        badgeColor = Theme
            .of(context)
            .primaryColor;
        break;
      case JoinProposalStateEnum.declined:
        badgeColor = Theme
            .of(context)
            .primaryColorLight;
        message = LocaleKeys.join_proposal_details_declined_text.tr();
        break;
      case JoinProposalStateEnum.rejected:
        badgeColor = Theme
            .of(context)
            .primaryColorLight;
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
                MyAvatar(
                  defaultImage: logoFamilyImages,
                  onTapCallback: () {},
                  radius: 60,
                  imageTag: "JOIN_PROPOSAL_${joinProposal.id ?? "XX"}",
                ),
                const MyHorizontalSeparator(),
                Container(
                  //color: Colors.red,
                  //width: MediaQuery.of(context).size.width/3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            LocaleKeys.join_proposal_details_family_label
                                .tr(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            LocaleKeys.join_proposal_details_status_label
                                .tr(),
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
            if(displayCancelButton) ...[
              MyButton(
                message:
                LocaleKeys.join_proposal_cancel_button.tr(),
                onPressed: () async {
                  await AlertHelper().confirm(
                    context,
                    LocaleKeys.join_proposal_cancel_confirm.tr(args: [joinProposal.family!.displayName]),
                    onConfirmCallback: () {
                      BlocProvider.of<JoinProposalBloc>(
                        context,
                      ).add(
                        JoinProposalEvent.cancel(connectedUser: connectedUser,
                          joinProposal: joinProposal,),
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
