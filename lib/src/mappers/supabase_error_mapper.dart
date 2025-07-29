import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorMapper implements IErrorMapper {
  const SupabaseErrorMapper();

  @override
  AppFailure? tryHandle(error, [StackTrace? stackTrace]) {
    if (!(error is AuthException ||
        error is PostgrestException ||
        error is StorageException ||
        error is RealtimeSubscribeException)) {
      return null;
    }

    final trace = stackTrace ?? StackTrace.current;

    if (error is AuthException) {
      final msg = error.message.toLowerCase();

      if (msg.contains('invalid login credentials')) {
        return AuthFailure('invalid_credentials', error.message, trace);
      } else if (msg.contains('user already registered')) {
        return AuthFailure('user_already_registered', error.message, trace);
      } else {
        return AuthFailure('supabase_auth_error', error.message, trace);
      }
    }

    if (error is PostgrestException) {
      final code = error.code?.toLowerCase();
      switch (code) {
        case '400':
          return ServerFailure('bad_request', error.message, trace);
        case '401':
          return AuthFailure('unauthorized', error.message, trace);
        case '403':
          return AuthFailure('forbidden', error.message, trace);
        case '404':
          return ServerFailure('not_found', error.message, trace);
        case '409':
          return ServerFailure('conflict', error.message, trace);
        case '500':
          return ServerFailure('internal_server_error', error.message, trace);
        default:
          return ServerFailure(
            'postgrest_error_${error.code}',
            error.message,
            trace,
          );
      }
    }

    if (error is StorageException) {
      final code = error.error;
      final msg = error.message.toLowerCase();

      if (code == 'InvalidJWT' || msg.contains('unauthorized')) {
        return AuthFailure('storage_unauthorized', error.message, trace);
      } else if (code == 'NoSuchBucket' || msg.contains('bucket not found')) {
        return ServerFailure('bucket_not_found', error.message, trace);
      } else if (code == 'NoSuchKey' || msg.contains('file not found')) {
        return ServerFailure('file_not_found', error.message, trace);
      } else if (code == 'EntityTooLarge' || msg.contains('too large')) {
        return ServerFailure('file_too_large', error.message, trace);
      } else {
        return ServerFailure('storage_error', error.message, trace);
      }
    }

    if (error is RealtimeSubscribeException) {
      switch (error.status) {
        case RealtimeSubscribeStatus.closed:
          return ServerFailure(
            'realtime_closed',
            'The realtime channel was closed unexpectedly.',
            trace,
          );
        case RealtimeSubscribeStatus.timedOut:
          return NetworkFailure(
            'realtime_timeout',
            'The realtime subscription request timed out.',
            trace,
          );
        default:
          return ServerFailure(
            'realtime_unknown_status',
            'Unknown realtime error: ${error.status.name}',
            trace,
          );
      }
    }

    return null;
  }
}
