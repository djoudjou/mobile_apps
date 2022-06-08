import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_user_failure.freezed.dart';

@freezed
class SearchUserFailure with _$SearchUserFailure {
  const factory SearchUserFailure.serverError() = ServerError;
}
