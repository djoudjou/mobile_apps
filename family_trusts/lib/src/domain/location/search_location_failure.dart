import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_location_failure.freezed.dart';

@freezed
abstract class SearchLocationFailure with _$SearchLocationFailure {
  const factory SearchLocationFailure.serverError() = ServerError;
}
