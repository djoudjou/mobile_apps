import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsInvitationsBloc
    extends SimpleLoaderBloc<List<Either<InvitationFailure, Invitation>>> {
  final INotificationRepository _notificationRepository;

  NotificationsInvitationsBloc(this._notificationRepository) : super();

  @override
  Stream<List<Either<InvitationFailure, Invitation>>> load(StartLoading event) {
    return _notificationRepository.getInvitations(event.userId!);
  }
}
