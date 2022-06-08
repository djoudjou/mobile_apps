import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/children_lookup/children_lookup_widget.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChildrenLookupDetailsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenLookupDetailsBloc, ChildrenLookupDetailsState>(
      listener: (bc, state) {
        if (state.isSubmitting) {
          showProgressMessage(LocaleKeys.global_update.tr(), bc);
        }

        state.failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(LocaleKeys.global_serverError.tr(), bc);
            },
            (_) {
              showSuccessMessage(LocaleKeys.global_success.tr(), bc);
            },
          ),
        );
      },
      child: BlocBuilder<ChildrenLookupDetailsBloc, ChildrenLookupDetailsState>(
        builder: (context, state) {
          if (state.isInitializing) {
            return const LoadingContent();
          } else {
            return SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //color: Colors.green,
                    child: ChildrenLookupWidget(
                      cardWidth: MediaQuery.of(context).size.width * .7,
                      childrenLookup: state.childrenLookup!,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (state.displayAcceptButton) ...[
                        MyButton(
                          message:
                              LocaleKeys.ask_childlookup_action_accept.tr(),
                          onPressed: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.global_confirm.tr(),
                              onConfirmCallback: () {
                                BlocProvider.of<ChildrenLookupDetailsBloc>(
                                  context,
                                ).add(
                                  const ChildrenLookupDetailsEvent.accept(),
                                );
                              },
                            );
                          },
                        )
                      ],
                      if (state.displayCancelButton) ...[
                        MyButton(
                          message:
                              LocaleKeys.ask_childlookup_action_cancel.tr(),
                          onPressed: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.global_confirm.tr(),
                              onConfirmCallback: () {
                                BlocProvider.of<ChildrenLookupDetailsBloc>(
                                  context,
                                ).add(
                                  const ChildrenLookupDetailsEvent.cancel(),
                                );
                              },
                            );
                          },
                        )
                      ],
                      if (state.displayEndedButton) ...[
                        MyButton(
                          message: LocaleKeys.ask_childlookup_action_end.tr(),
                          onPressed: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.global_confirm.tr(),
                              onConfirmCallback: () {
                                BlocProvider.of<ChildrenLookupDetailsBloc>(
                                  context,
                                ).add(
                                  const ChildrenLookupDetailsEvent.ended(),
                                );
                              },
                            );
                          },
                        )
                      ],
                      if (state.displayDeclineButton) ...[
                        MyButton(
                          message:
                              LocaleKeys.ask_childlookup_action_decline.tr(),
                          onPressed: () async {
                            await AlertHelper().confirm(
                              context,
                              LocaleKeys.global_confirm.tr(),
                              onConfirmCallback: () {
                                BlocProvider.of<ChildrenLookupDetailsBloc>(
                                  context,
                                ).add(
                                  const ChildrenLookupDetailsEvent.decline(),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ],
                  ),
                  const Divider(),
                  state.optionEitherChildrenLookupHistory.fold(
                    () => const EmptyContent(
                      size: 20.0,
                    ),
                    (eitherChildrenLookupHistory) =>
                        eitherChildrenLookupHistory.fold(
                      (failure) => const ErrorContent(
                        size: 20.0,
                      ),
                      (childrenLookupHistories) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: childrenLookupHistories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final idx =
                                childrenLookupHistories.length - index - 1;
                            final ChildrenLookupHistory childrenLookupHistory =
                                childrenLookupHistories[idx];

                            final isFirst =
                                idx == childrenLookupHistories.length - 1;
                            return TimelineTile(
                              alignment: TimelineAlign.manual,
                              lineXY: 0.35,
                              beforeLineStyle: LineStyle(
                                color: Theme.of(context).primaryColorLight,
                              ),
                              indicatorStyle: IndicatorStyle(
                                color: isFirst
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColorLight,
                              ),
                              isFirst: isFirst,
                              isLast: idx == 0,
                              startChild: MyText(
                                childrenLookupHistory
                                    .creationDate.toPrintableDate,
                              ),
                              endChild: Container(
                                //color: Colors.teal,
                                constraints: const BoxConstraints(
                                  minHeight: 60,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //color: Colors.red,
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      child: buildTimeLine(
                                        state.childrenLookup!,
                                        childrenLookupHistory,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildTimeLine(
    ChildrenLookup childrenLookup,
    ChildrenLookupHistory childrenLookupHistory,
  ) {
    switch (childrenLookupHistory.eventType.getOrCrash()) {
      case MissionEventTypeEnum.created:
        return MyText(
          LocaleKeys.ask_childlookup_event_created_template.tr(
            args: [
              childrenLookupHistory.subject.displayName,
            ],
          ),
          maxLines: 3,
        );
      case MissionEventTypeEnum.accepted:
        return MyText(
          LocaleKeys.ask_childlookup_event_accepted_template.tr(
            args: [
              childrenLookupHistory.subject.displayName,
            ],
          ),
          maxLines: 3,
        );
      case MissionEventTypeEnum.canceled:
        return MyText(
          LocaleKeys.ask_childlookup_event_canceled_template.tr(
            args: [
              childrenLookupHistory.subject.displayName,
            ],
          ),
          maxLines: 3,
        );
      case MissionEventTypeEnum.declined:
        return MyText(
          LocaleKeys.ask_childlookup_event_declined_template.tr(
            args: [
              childrenLookupHistory.subject.displayName,
            ],
          ),
          maxLines: 3,
        );
      case MissionEventTypeEnum.ended:
        return MyText(
          LocaleKeys.ask_childlookup_event_ended_template.tr(
            args: [
              childrenLookupHistory.subject.displayName,
              childrenLookup.child!.displayName,
            ],
          ),
          maxLines: 3,
        );
    }
  }
}
