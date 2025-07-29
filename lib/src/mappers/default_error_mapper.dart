import 'dart:io';

import '../interfaces/i_error_mapper.dart';
import '../models/app_failure.dart';

class DefaultErrorMapper implements IErrorMapper {
  const DefaultErrorMapper();

  @override
  AppFailure? tryHandle(error, [StackTrace? stackTrace]) {
    final trace = stackTrace ?? StackTrace.current;

    if (!(error is SocketException ||
        error is HttpException ||
        error is TlsException ||
        error is FormatException ||
        error is TypeError)) {
      return null;
    }

    if (error is SocketException ||
        error is HttpException ||
        error is TlsException) {
      return NetworkFailure('no_internet', error.message, trace);
    }

    if (error is FormatException) {
      return ServerFailure('invalid_format', error.message, trace);
    }

    if (error is TypeError) {
      return ServerFailure('type_error', error.toString(), trace);
    }

    return UnknownFailure(error.toString(), trace);
  }
}
