import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsUnseenBloc
    extends SimpleLoaderBloc<Either<NotificationsFailure, int>> {
  final IFamilyEventRepository _notificationRepository;

  NotificationsUnseenBloc(this._notificationRepository) : super();

  @override
  Future<Either<NotificationsFailure, int>> load(StartLoading event) {
    return _notificationRepository.getUnReadCount(event.userId!);
  }
}
