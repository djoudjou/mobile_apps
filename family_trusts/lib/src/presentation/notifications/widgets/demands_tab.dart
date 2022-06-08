import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/demands/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/core/children_lookup/children_lookup_widget.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemandsTab extends StatelessWidget {
  final User connectedUser;
  final _key = const PageStorageKey<String>('childrenLookup');

  DemandsTab({Key? key, required this.connectedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DemandsBloc>(
      create: (context) => getIt<DemandsBloc>()
        ..add(DemandsEvent.loadDemands(connectedUser.familyId)),
      child: BlocConsumer<DemandsBloc, DemandsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.map(
            demandsLoading: (demandsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LoadingContent(),
                  ],
                ),
              );
            },
            demandsLoaded: (demandsLoaded) {
              if (demandsLoaded.demands.isLeft()) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ErrorContent(),
                    ],
                  ),
                );
              } else {
                final List<ChildrenLookup> childrenLookups = demandsLoaded
                    .demands
                    .toOption()
                    .toNullable()!
                    .inProgressChildrenLookups;
                if (childrenLookups.isEmpty) {
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: MyText(
                        LocaleKeys.notifications_tabs_demands_empty.tr(),
                        style: FontStyle.italic,
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    key: _key,
                    padding: const EdgeInsets.all(8),
                    itemCount: childrenLookups.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ChildrenLookup childrenLookup =
                          childrenLookups[index];
                      return InkWell(
                        onTap: () {
                          context.pushRoute(
                            ChildrenLookupDetailsPageRoute(
                              childrenLookup: childrenLookup,
                            ),
                          );
                        },
                        child: ChildrenLookupWidget(
                          cardWidth: MediaQuery.of(context).size.width * .7,
                          childrenLookup: childrenLookup,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                }
              }
            },
            demandsNotLoaded: (demandsNotLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    ErrorContent(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
