import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_state.freezed.dart';

@freezed
class TabState with _$TabState {
  const factory TabState.ask() = Ask;

  const factory TabState.myDemands() = MyDemands;

  //const factory TabState.lookup(Option<Either<NotificationsFailure, Notifications>> optionFailureOrNotifications) = Lookup;
  const factory TabState.notification() = Notification;

  const factory TabState.me() = Me;
}
