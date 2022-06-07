
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/demands/demands.dart';
import 'package:familytrusts/src/domain/demands/demands_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'demands_event.freezed.dart';

@freezed
class DemandsEvent with _$DemandsEvent {
  const factory DemandsEvent.loadDemands(String? familyId) = LoadDemands;
  const factory DemandsEvent.demandsUpdated(Either<DemandsFailure, Demands> demands) = DemandsUpdated;
}

