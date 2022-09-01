import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsEventsBloc
    extends SimpleLoaderBloc<Either<EventFailure, List<Event>>> {
  final IFamilyEventRepository _notificationRepository;

  NotificationsEventsBloc(this._notificationRepository) : super();

  @override
  Future<Either<EventFailure, List<Event>>> load(StartLoading event) {
    return _notificationRepository.getEvents(event.userId!);
  }
}
