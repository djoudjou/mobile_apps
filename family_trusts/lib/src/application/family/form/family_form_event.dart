import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_form_event.freezed.dart';

@freezed
abstract class FamilyFormEvent with _$FamilyFormEvent {
  const factory FamilyFormEvent.init(String? familyId, Family family) =
      FamilyInit;

  const factory FamilyFormEvent.nameChanged(String name) = NameChanged;

  const factory FamilyFormEvent.saveFamily({
    required User connectedUser,
    required Family family,
  }) = SaveFamily;

  const factory FamilyFormEvent.deleteFamily({
    required User connectedUser,
    required Family family,
  }) = DeleteFamily;
}
