import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_success.freezed.dart';

@freezed
abstract class LocationSuccess with _$LocationSuccess {
  const factory LocationSuccess.updateSuccess() = _UpdateSuccess;

  const factory LocationSuccess.createSuccess() = _CreateSuccess;

  const factory LocationSuccess.deleteSucces() = _DeleteSucces;
}
