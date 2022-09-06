import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/demands/demands_bloc.dart';
import 'package:familytrusts/src/application/demands/demands_event.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/core/children_lookup/children_lookup_widget.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemandsInProgressTab extends StatelessWidget {
  final List<ChildrenLookup> childrenLookups;
  final User connectedUser;

  const DemandsInProgressTab({
    Key? key,
    required this.childrenLookups,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (childrenLookups.isEmpty) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: MyText(
            LocaleKeys.demands_tabs_empty.tr(),
            style: FontStyle.italic,
          ),
        ),
      );
    } else {
      return ListView.separated(
        key: const PageStorageKey<String>('demands_in_progress'),
        padding: const EdgeInsets.all(8),
        itemCount: childrenLookups.length,
        itemBuilder: (BuildContext context, int index) {
          final childrenLookup = childrenLookups[index];
          return InkWell(
            onTap: () {
              AutoRouter.of(context)
                  .push(
                ChildrenLookupDetailsPageRoute(
                  connectedUser: connectedUser,
                  childrenLookup: childrenLookup,
                ),
              )
                  .then((value) {
                if (value != null) {
                  BlocProvider.of<DemandsBloc>(
                    context,
                  ).add(
                    DemandsEvent.loadDemands(connectedUser.family!.id),
                  );
                }
              });
            },
            child: ChildrenLookupWidget(
              cardWidth: MediaQuery.of(context).size.width * .7,
              childrenLookup: childrenLookup,
              connectedUser: connectedUser,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }
  }
}

enum Direction {
  left,
  right,
}

class DemandDeleteBackground extends StatelessWidget {
  final Direction direction;

  const DemandDeleteBackground({
    Key? key,
    required this.direction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: (direction == Direction.left)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete, color: Colors.white),
            MyText(
              LocaleKeys.demands_tabs_moveToTrash.tr(),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
