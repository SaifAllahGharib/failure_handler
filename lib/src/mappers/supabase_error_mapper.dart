import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorMapper extends IErrorMapper {
  @override
  bool canHandle(error) =>
      error is AuthException ||
      error is PostgrestException ||
      error is StorageException ||
      error is RealtimeSubscribeException;

  @override
  AppFailure handle(error) {
    if (error is AuthException) {
      final msg = error.message.toLowerCase();

      if (msg.contains('invalid login credentials')) {
        return AuthFailure(
          'invalid_credentials',
          error.message,
          StackTrace.current,
        );
      } else if (msg.contains('user already registered')) {
        return AuthFailure(
          'user_already_registered',
          error.message,
          StackTrace.current,
        );
      } else {
        return AuthFailure(
          'supabase_auth_error',
          error.message,
          StackTrace.current,
        );
      }
    }

    if (error is PostgrestException) {
      final code = error.code?.toLowerCase();
      switch (code) {
        case '400':
          return ServerFailure(
            'bad_request',
            error.message,
            StackTrace.current,
          );
        case '401':
          return AuthFailure('unauthorized', error.message, StackTrace.current);
        case '403':
          return AuthFailure('forbidden', error.message, StackTrace.current);
        case '404':
          return ServerFailure('not_found', error.message, StackTrace.current);
        case '409':
          return ServerFailure('conflict', error.message, StackTrace.current);
        case '500':
          return ServerFailure(
            'internal_server_error',
            error.message,
            StackTrace.current,
          );
        default:
          return ServerFailure(
            'postgrest_error_${error.code}',
            error.message,
            StackTrace.current,
          );
      }
    }

    if (error is StorageException) {
      final code = error.error;
      final msg = error.message.toLowerCase();

      if (code == 'InvalidJWT' || msg.contains('unauthorized')) {
        return AuthFailure(
          'storage_unauthorized',
          error.message,
          StackTrace.current,
        );
      } else if (code == 'NoSuchBucket' || msg.contains('bucket not found')) {
        return ServerFailure(
          'bucket_not_found',
          error.message,
          StackTrace.current,
        );
      } else if (code == 'NoSuchKey' || msg.contains('file not found')) {
        return ServerFailure(
          'file_not_found',
          error.message,
          StackTrace.current,
        );
      } else if (code == 'EntityTooLarge' || msg.contains('too large')) {
        return ServerFailure(
          'file_too_large',
          error.message,
          StackTrace.current,
        );
      } else {
        return ServerFailure(
          'storage_error',
          error.message,
          StackTrace.current,
        );
      }
    }

    if (error is RealtimeSubscribeException) {
      switch (error.status) {
        case RealtimeSubscribeStatus.closed:
          return ServerFailure(
            'realtime_closed',
            'The realtime channel was closed unexpectedly.',
            StackTrace.current,
          );
        case RealtimeSubscribeStatus.timedOut:
          return NetworkFailure(
            'realtime_timeout',
            'The realtime subscription request timed out.',
            StackTrace.current,
          );
        default:
          return ServerFailure(
            'realtime_unknown_status',
            'Unknown realtime error: ${error.status.name}',
            StackTrace.current,
          );
      }
    }

    return UnknownFailure(error.toString(), StackTrace.current);
  }
}
