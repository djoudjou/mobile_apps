import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/demands/demands.dart';
import 'package:familytrusts/src/domain/demands/demands_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'demands_state.freezed.dart';

@freezed
class DemandsState with _$DemandsState {
  const factory DemandsState.demandsLoading() = DemandsLoading;

  const factory DemandsState.demandsLoaded(Either<DemandsFailure,Demands> demands) = DemandsLoaded;

  const factory DemandsState.demandsNotLoaded() = DemandsNotLoaded;
}
