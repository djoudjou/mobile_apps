import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart' as quiver;

class ChildrenLookupWidget extends StatelessWidget {
  const ChildrenLookupWidget({
    super.key,
    required this.cardWidth,
    required this.childrenLookup,
    required this.connectedUser,
  });

  final double cardWidth;
  final ChildrenLookup childrenLookup;
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    if (quiver.isBlank(childrenLookup.id)) {
      return Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyAvatar(
              defaultImage: childrenLookupImages,
              onTapCallback: () {},
              radius: 100,
              imageTag: "CHILDREN_LOOKUP",
            ),
            const MyVerticalSeparator(),
            const MyVerticalSeparator(),
            SizedBox(
              width: cardWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        LocaleKeys.ask_childlookup_confirm_msgLookupChild.tr(),
                      ),
                      const MyHorizontalSeparator(),
                      MyText(
                        childrenLookup.child!.displayName,
                        style: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        LocaleKeys.ask_childlookup_confirm_msgLookupLocation
                            .tr(),
                      ),
                      const MyHorizontalSeparator(),
                      MyText(
                        childrenLookup.location!.title.getOrCrash(),
                        style: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        LocaleKeys.ask_childlookup_confirm_msgLookupDate.tr(),
                      ),
                      const MyHorizontalSeparator(),
                      MyText(
                        childrenLookup.rendezVous.toText,
                        style: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        LocaleKeys.ask_childlookup_stepper_note_selection.tr(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: MyText(
                          childrenLookup.noteBody.getOrCrash(),
                          style: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const MyVerticalSeparator(),
            const MyVerticalSeparator(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  onPressed: () {
                    BlocProvider.of<ChildrenLookupBloc>(context)
                        .add(ChildrenLookupEvent.submitted(connectedUser));
                  },
                  message: LocaleKeys.ask_childlookup_confirm_confirm.tr(),
                ),
                MyButton(
                  onPressed: () {
                    BlocProvider.of<ChildrenLookupBloc>(context)
                        .add(const ChildrenLookupEvent.cancel());
                  },
                  backgroundColor: Colors.red,
                  message: LocaleKeys.ask_childlookup_confirm_cancel.tr(),
                ),
              ],
            ),
            const MyVerticalSeparator(),
            const MyVerticalSeparator(),
          ],
        ),
      );
    } else {
      Color badgeColor;
      String message;

      switch (childrenLookup.state!.getOrCrash()) {
        case MissionStateEnum.ACCEPTED:
          message = LocaleKeys.ask_childlookup_MissionState_accepted.tr();
          badgeColor = Theme.of(context).colorScheme.secondary;
          break;
        case MissionStateEnum.CANCELED:
          badgeColor = Theme.of(context).primaryColorLight;
          message = LocaleKeys.ask_childlookup_MissionState_canceled.tr();
          break;
        case MissionStateEnum.WAITING_RESPONSE:
          message = LocaleKeys.ask_childlookup_MissionState_waiting.tr();
          badgeColor = Theme.of(context).primaryColor;
          break;
        case MissionStateEnum.PICKEDUP:
          badgeColor = Theme.of(context).primaryColorLight;
          message = LocaleKeys.ask_childlookup_MissionState_pickedup.tr();
          break;

        case MissionStateEnum.REJECTED:
          badgeColor = Theme.of(context).colorScheme.secondary;
          message = LocaleKeys.ask_childlookup_MissionState_rejected.tr();
          break;
      }

      return SizedBox(
        width: double.infinity,
        child: Badge(
          shape: BadgeShape.square,
          borderRadius: BorderRadius.circular(20),
          position: BadgePosition.topStart(start: 10, top: 10),
          //position: BadgePosition.topEnd(end: 10,top: 10),
          animationDuration: const Duration(milliseconds: 300),
          //animationType: BadgeAnimationType.slide,
          badgeColor: badgeColor,
          badgeContent: Container(
            child: MyText(
              message,
              color: Colors.white,
              maxLines: 2,
            ),
          ),
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const MyVerticalSeparator(),
                const MyVerticalSeparator(),
                const MyVerticalSeparator(),
                const MyVerticalSeparator(),
                MyText(LocaleKeys.ask_childlookup_title.tr()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyAvatar(
                      defaultImage: childrenLookupImages,
                      onTapCallback: () {},
                      radius: 60,
                      imageTag: "CHILDREN_LOOKUP_${childrenLookup.id ?? "XX"}",
                    ),
                    const MyHorizontalSeparator(),
                    Container(
                      //color: Colors.red,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                LocaleKeys
                                    .ask_childlookup_confirm_msgLookupChild
                                    .tr(),
                              ),
                              const MyHorizontalSeparator(),
                              MyText(
                                childrenLookup.child!.displayName,
                                style: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                LocaleKeys
                                    .ask_childlookup_confirm_msgLookupLocation
                                    .tr(),
                              ),
                              const MyHorizontalSeparator(),
                              MyText(
                                childrenLookup.location!.title.getOrCrash(),
                                style: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                LocaleKeys.ask_childlookup_confirm_msgLookupDate
                                    .tr(),
                              ),
                              const MyHorizontalSeparator(),
                              MyText(
                                childrenLookup.rendezVous.toText,
                                style: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                LocaleKeys.ask_childlookup_confirm_msgLookupNote
                                    .tr(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: cardWidth * .8,
                                child: MyText(
                                  childrenLookup.noteBody.getOrCrash(),
                                  style: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (childrenLookup.personInCharge != null) ...[
                  MyAvatar(
                    imageTag:
                        "TAG_LOOKUP_PROFILE_${childrenLookup.id}_${childrenLookup.personInCharge?.id}",
                    photoUrl: childrenLookup.personInCharge?.photoUrl,
                    radius: 60,
                    onTapCallback: () {},
                    defaultImage: defaultUserImages,
                  ),
                  MyText(
                    childrenLookup.personInCharge!.displayName,
                    style: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                  const MyVerticalSeparator(),
                ]
              ],
            ),
          ),
        ),
      );
    }
  }
}
