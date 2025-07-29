import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';

class DioErrorMapper implements IErrorMapper {
  const DioErrorMapper();

  static String _extractDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      for (final key in ['message', 'error', 'error_message', 'detail']) {
        if (data.containsKey(key)) {
          final value = data[key];
          return value is String ? value : value.toString();
        }
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          final firstError = errors.first;
          return firstError is String ? firstError : firstError.toString();
        }
      }
    }
    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map<String, dynamic>) {
          return parsed['message']?.toString() ??
              parsed['error']?.toString() ??
              data;
        }
      } catch (_) {}
      return data;
    }
    return error.message ?? 'An unexpected error occurred';
  }

  @override
  AppFailure? tryHandle(error, [StackTrace? stackTrace]) {
    if (error is! DioException) return null;

    final type = error.type;
    final statusCode = error.response?.statusCode;
    final msg = _extractDioMessage(error);
    final trace = stackTrace ?? StackTrace.current;

    switch (type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure('connection_timeout', msg, trace);
      case DioExceptionType.sendTimeout:
        return NetworkFailure('send_timeout', msg, trace);
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('receive_timeout', msg, trace);
      case DioExceptionType.badCertificate:
        return ServerFailure('bad_certificate', msg, trace);
      case DioExceptionType.badResponse:
        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure('unauthorized', msg, trace);
        } else if (statusCode == 404) {
          return ServerFailure('not_found', msg, trace);
        } else if (statusCode == 429) {
          return ServerFailure('too_many_requests', msg, trace);
        } else if (statusCode == 500) {
          return ServerFailure('internal_server_error', msg, trace);
        } else if (statusCode == 502) {
          return ServerFailure('bad_gateway', msg, trace);
        } else {
          return ServerFailure('bad_response_$statusCode', msg, trace);
        }
      case DioExceptionType.cancel:
        return ServerFailure('cancelled', 'Request was cancelled.', trace);
      case DioExceptionType.connectionError:
        return NetworkFailure('connection_error', msg, trace);
      case DioExceptionType.unknown:
        return UnknownFailure(msg, trace);
    }
  }
}
