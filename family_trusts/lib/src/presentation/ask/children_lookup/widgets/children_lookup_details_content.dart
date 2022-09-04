import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/children_lookup/children_lookup_widget.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChildrenLookupDetailsContent extends StatelessWidget {
  final User connectedUser;

  const ChildrenLookupDetailsContent({Key? key, required this.connectedUser})
      : super(key: key);

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
        builder: (contextChildrenLookupDetailsBloc, state) {
          if (state.isInitializing) {
            return const LoadingContent();
          } else {
            return state.optionChildrenLookupDetails.fold(
              () => const LoadingContent(),
              (childrenLookupDetails) => SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.green,
                      child: ChildrenLookupWidget(
                        cardWidth:
                            MediaQuery.of(contextChildrenLookupDetailsBloc)
                                    .size
                                    .width *
                                .7,
                        childrenLookup: childrenLookupDetails.childrenLookup,
                        connectedUser: connectedUser,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyButton(
                          message:
                              LocaleKeys.ask_childlookup_action_cancel.tr(),
                          onPressed: () async {
                            await AlertHelper().confirm(
                              contextChildrenLookupDetailsBloc,
                              LocaleKeys.global_confirm.tr(),
                              onConfirmCallback: () {
                                BlocProvider.of<ChildrenLookupDetailsBloc>(
                                  contextChildrenLookupDetailsBloc,
                                ).add(
                                  ChildrenLookupDetailsEvent.cancel(
                                    connectedUser: connectedUser,
                                    childrenLookup:
                                        childrenLookupDetails.childrenLookup,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    const Divider(),
                    if (childrenLookupDetails.histories.isEmpty) ...[
                      const EmptyContent(
                        size: 20.0,
                      ),
                    ],
                    if (childrenLookupDetails.histories.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: childrenLookupDetails.histories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final idx = childrenLookupDetails.histories.length -
                              index -
                              1;
                          final ChildrenLookupHistory childrenLookupHistory =
                              childrenLookupDetails.histories[idx];

                          final isFirst =
                              idx == childrenLookupDetails.histories.length - 1;
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
                              childrenLookupHistory.creationDate.toPrintableDate,
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
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    child: MyText(
                                      childrenLookupHistory.message,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
