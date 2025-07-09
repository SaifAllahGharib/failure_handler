import 'package:dio/dio.dart';
import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';

class DioErrorMapper extends IErrorMapper {
  @override
  bool canHandle(error) => error is DioException;

  @override
  AppFailure handle(error) {
    if (error is DioException) {
      final type = error.type;
      final statusCode = error.response?.statusCode;
      final msg = _extractDioMessage(error);

      switch (type) {
        case DioExceptionType.connectionTimeout:
          return NetworkFailure('connection_timeout', msg, StackTrace.current);

        case DioExceptionType.sendTimeout:
          return NetworkFailure('send_timeout', msg, StackTrace.current);

        case DioExceptionType.receiveTimeout:
          return NetworkFailure('receive_timeout', msg, StackTrace.current);

        case DioExceptionType.badCertificate:
          return ServerFailure('bad_certificate', msg, StackTrace.current);

        case DioExceptionType.badResponse:
          if (statusCode == 401 || statusCode == 403) {
            return AuthFailure('unauthorized', msg, StackTrace.current);
          } else if (statusCode == 404) {
            return ServerFailure('not_found', msg, StackTrace.current);
          } else if (statusCode == 429) {
            return ServerFailure('too_many_requests', msg, StackTrace.current);
          } else if (statusCode == 500) {
            return ServerFailure(
              'internal_server_error',
              msg,
              StackTrace.current,
            );
          } else if (statusCode == 502) {
            return ServerFailure('bad_gateway', msg, StackTrace.current);
          } else {
            return ServerFailure(
              'bad_response_$statusCode',
              msg,
              StackTrace.current,
            );
          }

        case DioExceptionType.cancel:
          return ServerFailure(
            'cancelled',
            'Request was cancelled.',
            StackTrace.current,
          );

        case DioExceptionType.connectionError:
          return NetworkFailure('connection_error', msg, StackTrace.current);

        case DioExceptionType.unknown:
          return UnknownFailure(msg ?? 'Unknown Dio error', StackTrace.current);
      }
    }

    return UnknownFailure(error.toString(), StackTrace.current);
  }

  static String? _extractDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('error')) return data['error'].toString();
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }
    if (data is String) return data;
    return error.message;
  }
}
