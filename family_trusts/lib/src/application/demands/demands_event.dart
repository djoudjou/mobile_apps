import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'demands_event.freezed.dart';

@freezed
class DemandsEvent with _$DemandsEvent {
  const factory DemandsEvent.loadDemands(String? familyId) = LoadDemands;
}
