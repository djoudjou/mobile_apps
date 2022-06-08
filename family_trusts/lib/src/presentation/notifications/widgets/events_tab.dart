import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/bloc.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/error_content.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsTab extends StatelessWidget with LogMixin {
  final User connectedUser;
  final _key = const PageStorageKey<String>('events');

  EventsTab({
    Key? key,
    required this.connectedUser,
  }) : super(key: key);

  String formatMessage(Event event) {
    String msg = "";
    final String to = event.to.displayName;

    final subject = event.subject;
    switch (event.type.getOrCrash()) {
      case EventTypeEnum.spouseProposal:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_spouseProposal_fromConnectedUser.tr(args: [to])
            : LocaleKeys.events_spouseProposal_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.spouseProposalCanceled:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_spouseProposalCanceled_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_spouseProposalCanceled_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.spouseProposalDeclined:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_spouseProposalDeclined_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_spouseProposalDeclined_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.spouseProposalAccepted:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_spouseProposalAccepted_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_spouseProposalAccepted_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.trustProposal:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustProposal_fromConnectedUser.tr(args: [to])
            : LocaleKeys.events_trustProposal_notFromConnectedUser
                .tr(args: [event.from.displayName]);

        break;
      case EventTypeEnum.trustProposalCanceled:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustProposalCanceled_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_trustProposalCanceled_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.trustProposalDeclined:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustProposalDeclined_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_trustProposalDeclined_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.childAdded:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childAdded_fromConnectedUser.tr(args: [subject])
            : LocaleKeys.events_childAdded_notFromConnectedUser.tr(
                args: [
                  event.from.displayName,
                  subject,
                ],
              );
        break;
      case EventTypeEnum.childRemoved:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childRemoved_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childRemoved_notFromConnectedUser.tr(
                args: [
                  event.from.displayName,
                  subject,
                ],
              );
        break;
      case EventTypeEnum.childUpdated:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childUpdated_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childUpdated_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.spouseRemoved:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_spouseRemoved_fromConnectedUser.tr(args: [to])
            : LocaleKeys.events_spouseRemoved_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.trustRemoved:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustRemoved_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_trustRemoved_notFromConnectedUser.tr(
                args: [event.from.displayName, subject],
              );
        break;
      case EventTypeEnum.trustAdded:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustAdded_fromConnectedUser.tr(args: [subject])
            : LocaleKeys.events_trustAdded_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.trustProposalAccepted:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_trustProposalAccepted_fromConnectedUser
                .tr(args: [to])
            : LocaleKeys.events_trustProposalAccepted_notFromConnectedUser
                .tr(args: [event.from.displayName]);
        break;
      case EventTypeEnum.locationAdded:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_locationAdded_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_locationAdded_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.locationUpdated:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_locationUpdated_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_locationUpdated_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.locationRemoved:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_locationRemoved_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_locationRemoved_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.childrenLookupAdded:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childrenLookupAdded_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childrenLookupAdded_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;

      case EventTypeEnum.childrenLookupAccepted:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childrenLookupAccepted_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childrenLookupAccepted_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.childrenLookupDecline:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childrenLookupDecline_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childrenLookupDecline_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.childrenLookupEnded:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childrenLookupEnded_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childrenLookupEnded_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
      case EventTypeEnum.childrenLookupCanceled:
        msg = (event.fromConnectedUser)
            ? LocaleKeys.events_childrenLookupCanceled_fromConnectedUser
                .tr(args: [subject])
            : LocaleKeys.events_childrenLookupCanceled_notFromConnectedUser
                .tr(args: [event.from.displayName, subject]);
        break;
    }

    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsEventsUpdateBloc>(
      create: (context) => getIt<NotificationsEventsUpdateBloc>(),
      child: BlocProvider<NotificationsEventsBloc>(
        create: (context) => getIt<NotificationsEventsBloc>()
          ..add(SimpleLoaderEvent.startLoading(connectedUser.id)),
        child: BlocListener<NotificationsEventsUpdateBloc,
            NotificationsEventsUpdateState>(
          listener: (context, state) {
            state.markAsReadfailureOrSuccessOption.fold(
              () => null,
              (result) => result.fold(
                (l) => showErrorMessage(
                  LocaleKeys.global_unexpected.tr(),
                  context,
                ),
                (r) => null,
              ),
            );
            state.deletefailureOrSuccessOption.fold(
              () => null,
              (result) => result.fold(
                (l) => showErrorMessage(
                  LocaleKeys.global_unexpected.tr(),
                  context,
                ),
                (r) => null,
              ),
            );
          },
          child: BlocConsumer<NotificationsEventsBloc, SimpleLoaderState>(
            listener: (context, state) {},
            builder: (context, state) {
              return state.maybeMap(
                simpleSuccessEventState: (simpleSuccessEventState) {
                  final List<Either<EventFailure, Event>> eventsResult =
                      simpleSuccessEventState.items
                          as List<Either<EventFailure, Event>>;
                  final events = eventsResult
                      .where((element) => element.isRight())
                      .map((e) => e.toOption().toNullable()!)
                      .toList();
                  if (events.isEmpty) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: MyText(
                          LocaleKeys.events_empty.tr(),
                          style: FontStyle.italic,
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      key: _key,
                      padding: const EdgeInsets.all(8),
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = events[index];
                        return Dismissible(
                          key: Key(event.id!),
                          background: const EventDeleteWidget(),
                          secondaryBackground: const EventDeleteWidget(),
                          onDismissed: (DismissDirection direction) {
                            context.read<NotificationsEventsUpdateBloc>().add(
                                  NotificationsEventsUpdateEvent.deleteEvent(
                                    connectedUser,
                                    event,
                                  ),
                                );
                          },
                          child: InkWell(
                            onTap: (event.seen)
                                ? null
                                : () => context
                                    .read<NotificationsEventsUpdateBloc>()
                                    .add(
                                      NotificationsEventsUpdateEvent.markAsRead(
                                        connectedUser,
                                        event,
                                      ),
                                    ),
                            child: Container(
                              color: event.seen ? Colors.grey : null,
                              child: ListTile(
                                title: MyText(
                                  event.date.toPrintableDate,
                                  alignment: TextAlign.start,
                                ),
                                subtitle: MyText(
                                  formatMessage(event),
                                  style: event.seen
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  maxLines: 3,
                                  alignment: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  }
                },
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
        ),
      ),
    );
  }
}

class EventDeleteWidget extends StatelessWidget {
  const EventDeleteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.delete, color: Colors.white),
            MyText(
              LocaleKeys.events_moveToTrash.tr(),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
