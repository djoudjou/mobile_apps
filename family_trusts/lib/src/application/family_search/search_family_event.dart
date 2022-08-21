import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_family_event.freezed.dart';

@freezed
class SearchFamilyEvent with _$SearchFamilyEvent {
  const factory SearchFamilyEvent.familyLookupChanged(String familyLookupText) =
      FamilyLookupChanged;
}
