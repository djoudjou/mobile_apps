import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_loader_failure.freezed.dart';

@freezed
abstract class SimpleLoaderFailure with _$SimpleLoaderFailure {
  const factory SimpleLoaderFailure.unexpected() = _Unexpected;
  const factory SimpleLoaderFailure.insufficientPermission() = _InsufficientPermission;
}
