import 'package:familytrusts/src/infrastructure/http/http_response_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_failure.freezed.dart';

@freezed
abstract class HttpFailure with _$HttpFailure {
  const factory HttpFailure.technicalError() = _TechnicalFailure;
  const factory HttpFailure.insufficientPermission() = _InsufficientPermission;
  const factory HttpFailure.serverError(int status, HttpResponseDTO response) =
      _ServerError;
}
