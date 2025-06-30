import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_failure.dart';

class ErrorHandler {
  static AppFailure handle(dynamic error) {
    /// -------------------- FirebaseAuthException --------------------
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return AuthFailure(
            'user_not_found',
            error.message,
            StackTrace.current,
          );
        case 'wrong-password':
          return AuthFailure(
            'wrong_password',
            error.message,
            StackTrace.current,
          );
        case 'email-already-in-use':
          return AuthFailure('email_in_use', error.message, StackTrace.current);
        case 'invalid-email':
          return AuthFailure(
            'invalid_email',
            error.message,
            StackTrace.current,
          );
        case 'weak-password':
          return AuthFailure(
            'weak_password',
            error.message,
            StackTrace.current,
          );
        case 'user-disabled':
          return AuthFailure(
            'user_disabled',
            error.message,
            StackTrace.current,
          );
        case 'too-many-requests':
          return AuthFailure(
            'too_many_requests',
            error.message,
            StackTrace.current,
          );
        case 'network-request-failed':
          return NetworkFailure(
            'firebase_network_error',
            error.message,
            StackTrace.current,
          );
        case 'account-exists-with-different-credential':
          return AuthFailure(
            'account_exists_different_credential',
            error.message,
            StackTrace.current,
          );
        default:
          return AuthFailure('auth_error', error.message, StackTrace.current);
      }
    }

    /// -------------------- FirebaseException --------------------
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return ServerFailure(
          'permission_denied',
          error.message,
          StackTrace.current,
        );
      }
      if (error.plugin == 'firebase_database') {
        return ServerFailure(
          'firebase_database_error',
          error.message,
          StackTrace.current,
        );
      }
      if (error.plugin == 'cloud_firestore') {
        return ServerFailure(
          'firestore_error',
          error.message,
          StackTrace.current,
        );
      }
      return ServerFailure('firebase_error', error.message, StackTrace.current);
    }

    /// -------------------- DioException --------------------
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

    /// ------------- SocketException, HttpException, TlsException -------------
    if (error is SocketException ||
        error is HttpException ||
        error is TlsException) {
      return NetworkFailure('no_internet', error.message, StackTrace.current);
    }

    /// -------------------- FormatException --------------------
    if (error is FormatException) {
      return ServerFailure('invalid_format', error.message, StackTrace.current);
    }

    /// -------------------- TypeError --------------------
    if (error is TypeError) {
      return ServerFailure('type_error', error.toString(), StackTrace.current);
    }

    /// -------------------- Unknown --------------------
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
