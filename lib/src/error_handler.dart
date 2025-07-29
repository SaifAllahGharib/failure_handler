import 'package:failure_handler/src/error_logger.dart';

import 'interfaces/i_error_mapper.dart';
import 'models/app_failure.dart';
import 'models/result.dart';

class ErrorHandler {
  final List<IErrorMapper> _mappers;
  final ErrorLogger _errorLogger;

  const ErrorHandler(this._mappers, this._errorLogger);

  AppFailure handle(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;

    for (final mapper in _mappers) {
      final result = mapper.tryHandle(error, stackTrace);
      if (result != null) return result;
    }

    return UnknownFailure(error.toString(), stackTrace ?? StackTrace.current);
  }

  Future<Result<AppFailure, T>> handleFutureWithTryCatch<T>(
    Future<T> Function() action,
  ) async {
    try {
      return Success(await action());
    } catch (e, stackTrace) {
      final failure = handle(e, stackTrace);
      _errorLogger.logError(failure, e);
      return Failure(failure);
    }
  }

  Stream<Result<AppFailure, T>> handleStreamWithTryCatch<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield Success(value);
      }
    } catch (e, stackTrace) {
      final failure = handle(e, stackTrace);
      _errorLogger.logError(failure, e);
      yield Failure(failure);
    }
  }
}
