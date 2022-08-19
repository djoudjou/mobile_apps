import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_success.freezed.dart';

@freezed
abstract class FamilySuccess with _$FamilySuccess {
  const factory FamilySuccess.updateSuccess() = _UpdateSuccess;

  const factory FamilySuccess.createSuccess() = _CreateSuccess;

  const factory FamilySuccess.deleteSucces() = _DeleteSucces;
}
