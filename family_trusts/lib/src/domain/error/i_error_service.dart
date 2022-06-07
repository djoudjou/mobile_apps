

abstract class IErrorService {
  Future<void> logInfo(String message, [Map<String, dynamic>? data]);

  Future<void> logError(String message, [Map<String, dynamic>? data]);

  Future<void> logWarning(String message, [Map<String, dynamic>? data]);

  Future<void> logException(Object error,
      {String? message, StackTrace? stackTrace});
}
