import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_event.freezed.dart';

@freezed
class ChildrenLookupEvent with _$ChildrenLookupEvent {
  const factory ChildrenLookupEvent.init(String? familyId) = ChildrenLookupInit;

  const factory ChildrenLookupEvent.noteChanged(String note) = NoteChanged;

  const factory ChildrenLookupEvent.childSelected(Child child) = ChildSelected;

  const factory ChildrenLookupEvent.locationSelected(Location location) =
      LocationSelected;

  const factory ChildrenLookupEvent.rendezVousChanged(DateTime dateTime) =
      RendezVousChanged;

  const factory ChildrenLookupEvent.submitted(User connectedUser) = Submitted;

  const factory ChildrenLookupEvent.next() = Next;

  const factory ChildrenLookupEvent.cancel() = Cancel;

  const factory ChildrenLookupEvent.goTo(int step) = Goto;
}
