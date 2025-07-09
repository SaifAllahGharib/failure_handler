import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorMapper extends IErrorMapper {
  @override
  bool canHandle(error) =>
      error is FirebaseAuthException || error is FirebaseException;

  @override
  AppFailure handle(error) {
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

    return UnknownFailure(error.toString(), StackTrace.current);
  }
}
