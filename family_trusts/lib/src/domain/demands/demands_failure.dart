import 'package:freezed_annotation/freezed_annotation.dart';

part 'demands_failure.freezed.dart';

@freezed
abstract class DemandsFailure with _$DemandsFailure {
  const factory DemandsFailure.serverError() = _ServerError;
  const factory DemandsFailure.insufficientPermission() = _InsufficientPermission;
}
