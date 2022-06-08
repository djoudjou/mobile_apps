import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_user_event.freezed.dart';

@freezed
class SearchUserEvent with _$SearchUserEvent {
  const factory SearchUserEvent.userLookupChanged(String userLookupText) =
      UserLookupChanged;
}
