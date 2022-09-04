import 'package:freezed_annotation/freezed_annotation.dart';

part 'picture_failure.freezed.dart';

@freezed
abstract class PictureFailure with _$PictureFailure {
  const factory PictureFailure.unexpected() = _Unexpected;
  const factory PictureFailure.insufficientPermission() = _InsufficientPermission;
}
