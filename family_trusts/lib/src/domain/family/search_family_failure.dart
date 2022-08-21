import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_family_failure.freezed.dart';

@freezed
class SearchFamilyFailure with _$SearchFamilyFailure {
  const factory SearchFamilyFailure.serverError() = ServerError;
}
