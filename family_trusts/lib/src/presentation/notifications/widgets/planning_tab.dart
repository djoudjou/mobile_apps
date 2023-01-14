import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/planning/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_entry.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/date_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanningTab extends StatelessWidget with LogMixin {
  final User connectedUser;
  final _key = const PageStorageKey<String>('planning');
  final radius = 70;

  PlanningTab({super.key, required this.connectedUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlanningBloc>(
      create: (context) => PlanningBloc(
        getIt<IChildrenLookupRepository>(),
        getIt<IUserRepository>(),
      )..add(SimpleLoaderEvent.startLoading(userId: connectedUser.id)),
      child: BlocConsumer<PlanningBloc, SimpleLoaderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LoadingContent(),
                ],
              ),
            ),
            simpleErrorEventState: (simpleErrorEventState) => buildError(),
            simpleSuccessEventState: (simpleSuccessEventState) {
              final Either<PlanningFailure, Planning> items =
                  simpleSuccessEventState.items
                      as Either<PlanningFailure, Planning>;

              return items.fold(
                (l) => buildError(),
                (planning) => buildPlanning(planning, context),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildPlanning(Planning planning, BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * (3 / 4 / 2);
    return ListView.separated(
      key: _key,
      padding: const EdgeInsets.all(8),
      itemCount: planning.entries.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final PlanningEntry entry = planning.entries[index];

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          //color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyVerticalSeparator(),
                  Container(
                    alignment: Alignment.center,
                    //color: Colors.blueAccent,
                    child: MyText(getDateToString(entry.day)),
                  ),
                  const MyVerticalSeparator(),
                  //MyText(entry.childrenLookups.length.toString()),
                  Column(
                    children: entry.childrenLookups.map((e) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * (3 / 4),
                        //color: Colors.brown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              //color:Colors.green,
                              child: MyAvatar(
                                imageTag: "TAG_CHILD_${e.child?.id}",
                                photoUrl: e.child?.photoUrl,
                                radius: radius / 1.5,
                                onTapCallback: () => log("click"),
                                defaultImage: defaultUserImages,
                              ),
                            ),
                            Container(
                              //color: Colors.amberAccent,
                              //width: MediaQuery.of(context).size.width * (3/4/2),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MyText(
                                        e.child!.displayName,
                                        style: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: cardWidth,
                                        child: MyText(
                                          e.location!.title.getOrCrash(),
                                          style: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MyText(
                                        e.rendezVous.toHourText,
                                        style: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Center buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ErrorContent(),
        ],
      ),
    );
  }
}
