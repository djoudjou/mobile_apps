import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:injectable/injectable.dart';


@injectable
class NotificationsEventsBloc
    extends SimpleLoaderBloc<List<Either<EventFailure, Event>>> {
  final INotificationRepository _notificationRepository;

  NotificationsEventsBloc(this._notificationRepository):super();

  @override
  Stream<List<Either<EventFailure, Event>>> load(StartLoading event) {
    return _notificationRepository.getEvents(event.userId!);
  }
}
