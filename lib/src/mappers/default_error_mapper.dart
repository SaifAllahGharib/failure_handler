import 'dart:io';

import '../interfaces/i_error_mapper.dart';
import '../models/app_failure.dart';

class DefaultErrorMapper implements IErrorMapper {
  @override
  bool canHandle(dynamic error) =>
      error is SocketException ||
      error is HttpException ||
      error is TlsException ||
      error is FormatException ||
      error is TypeError;

  @override
  AppFailure handle(dynamic error) {
    if (error is SocketException ||
        error is HttpException ||
        error is TlsException) {
      return NetworkFailure('no_internet', error.message, StackTrace.current);
    }

    if (error is FormatException) {
      return ServerFailure('invalid_format', error.message, StackTrace.current);
    }

    if (error is TypeError) {
      return ServerFailure('type_error', error.toString(), StackTrace.current);
    }

    return UnknownFailure(error.toString(), StackTrace.current);
  }
}
