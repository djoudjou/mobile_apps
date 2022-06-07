import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

part 'tab_event.freezed.dart';

@freezed
class TabEvent with _$TabEvent {
  const factory TabEvent.init(AppTab currentTab, String connectedUserId) = Init;

  const factory TabEvent.gotoAsk() = GotoAsk;

  const factory TabEvent.gotoMyDemands() = GotoMyDemands;

  //const factory TabEvent.gotoLookup() = GotoLookup;
  const factory TabEvent.gotoNotification() = GotoNotification;

  const factory TabEvent.gotoMe() = GotoMe;
}
