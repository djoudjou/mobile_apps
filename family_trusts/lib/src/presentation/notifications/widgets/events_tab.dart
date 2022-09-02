import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/bloc.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
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

  void refresh(BuildContext context) {
    BlocProvider.of<NotificationsEventsBloc>(
      context,
    ).add(
      SimpleLoaderEvent.startLoading(
        connectedUser.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsEventsUpdateBloc>(
      create: (context) =>
          NotificationsEventsUpdateBloc(getIt<IFamilyEventRepository>()),
      child: BlocProvider<NotificationsEventsBloc>(
        create: (context) =>
            NotificationsEventsBloc(getIt<IFamilyEventRepository>())
              ..add(SimpleLoaderEvent.startLoading(connectedUser.id)),
        child: BlocListener<NotificationsEventsUpdateBloc,
            NotificationsEventsUpdateState>(
          listener: (contextNotificationsEventsUpdateBloc, state) {
            state.markAsReadFailureOrSuccessOption.fold(
              () => null,
              (result) => result.fold(
                (failure) => showErrorMessage(
                  LocaleKeys.global_unexpected.tr(),
                  contextNotificationsEventsUpdateBloc,
                  onDismissed: () =>
                      refresh(contextNotificationsEventsUpdateBloc),
                ),
                (success) => refresh(contextNotificationsEventsUpdateBloc),
              ),
            );
            state.deleteFailureOrSuccessOption.fold(
              () => null,
              (result) => result.fold(
                (failure) => showErrorMessage(
                  LocaleKeys.global_unexpected.tr(),
                  contextNotificationsEventsUpdateBloc,
                  onDismissed: () =>
                      refresh(contextNotificationsEventsUpdateBloc),
                ),
                (success) => refresh(contextNotificationsEventsUpdateBloc),
              ),
            );
          },
          child: BlocConsumer<NotificationsEventsBloc, SimpleLoaderState>(
            listener: (context, state) {},
            builder: (contextNotificationsEventsBloc, state) {
              return state.maybeMap(
                simpleSuccessEventState: (simpleSuccessEventState) {
                  final Either<EventFailure, List<Event>> eventsResult =
                      simpleSuccessEventState.items
                          as Either<EventFailure, List<Event>>;

                  return eventsResult.fold(
                    (failure) => Center(
                      child: Container(
                        width: MediaQuery.of(contextNotificationsEventsBloc)
                            .size
                            .width,
                        child: MyText(
                          LocaleKeys.events_empty.tr(),
                          style: FontStyle.italic,
                        ),
                      ),
                    ),
                    (events) => events.isEmpty
                        ? const EmptyContent()
                        : ListView.separated(
                            key: _key,
                            padding: const EdgeInsets.all(8),
                            itemCount: events.length,
                            itemBuilder:
                                (BuildContext contextEvents, int index) {
                              final event = events[index];
                              return Dismissible(
                                key: Key(event.id!),
                                background: const EventDeleteWidget(),
                                secondaryBackground: const EventDeleteWidget(),
                                onDismissed: (DismissDirection direction) {
                                  contextEvents
                                      .read<NotificationsEventsUpdateBloc>()
                                      .add(
                                        NotificationsEventsUpdateEvent
                                            .deleteEvent(
                                          connectedUser,
                                          event,
                                        ),
                                      );
                                },
                                child: InkWell(
                                  onTap: (event.seen)
                                      ? null
                                      : () => contextEvents
                                          .read<NotificationsEventsUpdateBloc>()
                                          .add(
                                            NotificationsEventsUpdateEvent
                                                .markAsRead(
                                              connectedUser,
                                              event,
                                            ),
                                          ),
                                  child: Container(
                                    color: event.seen ? Colors.grey : null,
                                    child: ListTile(
                                      title: MyText(
                                        event.dateText,
                                        alignment: TextAlign.start,
                                      ),
                                      subtitle: MyText(
                                        event.message,
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
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          ),
                  );
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
