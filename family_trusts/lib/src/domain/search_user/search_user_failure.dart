import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'search_user_failure.freezed.dart';

@freezed
class SearchUserFailure with _$SearchUserFailure {
  const factory SearchUserFailure.serverError() = ServerError;
}
