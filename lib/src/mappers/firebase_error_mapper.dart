import 'package:failure_handler/src/interfaces/i_error_mapper.dart';
import 'package:failure_handler/src/models/app_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorMapper implements IErrorMapper {
  const FirebaseErrorMapper();

  @override
  AppFailure? tryHandle(error, [StackTrace? stackTrace]) {
    if (!(error is FirebaseAuthException || error is FirebaseException)) {
      return null;
    }

    final trace = stackTrace ?? StackTrace.current;

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return AuthFailure('user_not_found', error.message, trace);
        case 'email-already-exists':
        case 'email-already-in-use':
          return AuthFailure('email_in_use', error.message, trace);
        case 'network-request-failed':
          return AuthFailure('network_request_failed', error.message, trace);
        case 'invalid-email':
          return AuthFailure('invalid_email', error.message, trace);
        case 'invalid-email-verified':
          return AuthFailure('invalid_email_verified', error.message, trace);
        case 'too-many-requests':
          return AuthFailure('too_many_requests', error.message, trace);
        case 'id-token-expired':
          return AuthFailure('id_token_expired', error.message, trace);
        case 'id-token-revoked':
          return AuthFailure('id_token_revoked', error.message, trace);
        case 'insufficient-permission':
          return AuthFailure('insufficient_permission', error.message, trace);
        case 'internal-error':
          return AuthFailure('internal_error', error.message, trace);
        case 'invalid-argument':
          return AuthFailure('invalid_argument', error.message, trace);
        case 'invalid-claims':
          return AuthFailure('invalid_claims', error.message, trace);
        case 'claims-too-large':
          return AuthFailure('claims_too_large', error.message, trace);
        case 'invalid-continue-uri':
          return AuthFailure('invalid_continue_uri', error.message, trace);
        case 'invalid-creation-time':
          return AuthFailure('invalid_creation_time', error.message, trace);
        case 'invalid-credential':
          return AuthFailure('invalid_credential', error.message, trace);
        case 'invalid-disabled-field':
          return AuthFailure('invalid_disabled_field', error.message, trace);
        case 'invalid-display-name':
          return AuthFailure('invalid_display_name', error.message, trace);
        case 'invalid-dynamic-link-domain':
          return AuthFailure(
            'invalid_dynamic_link_domain',
            error.message,
            trace,
          );
        case 'invalid-hash-algorithm':
          return AuthFailure('invalid_hash_algorithm', error.message, trace);
        case 'invalid-hash-block-size':
          return AuthFailure('invalid_hash_block_size', error.message, trace);
        case 'invalid-hash-derived-key-length':
          return AuthFailure(
            'invalid_hash_derived_key_length',
            error.message,
            trace,
          );
        case 'invalid-hash-key':
          return AuthFailure('invalid_hash_key', error.message, trace);
        case 'invalid-hash-memory-cost':
          return AuthFailure('invalid_hash_memory_cost', error.message, trace);
        case 'invalid-hash-parallelization':
          return AuthFailure(
            'invalid_hash_parallelization',
            error.message,
            trace,
          );
        case 'invalid-hash-rounds':
          return AuthFailure('invalid_hash_rounds', error.message, trace);
        case 'invalid-hash-salt-separator':
          return AuthFailure(
            'invalid_hash_salt_separator',
            error.message,
            trace,
          );
        case 'invalid-id-token':
          return AuthFailure('invalid_id_token', error.message, trace);
        case 'invalid-last-sign-in-time':
          return AuthFailure('invalid_last_sign_in_time', error.message, trace);
        case 'invalid-page-token':
          return AuthFailure('invalid_page_token', error.message, trace);
        case 'invalid-password':
          return AuthFailure('invalid_password', error.message, trace);
        case 'invalid-password-hash':
          return AuthFailure('invalid_password_hash', error.message, trace);
        case 'invalid-password-salt':
          return AuthFailure('invalid_password_salt', error.message, trace);
        case 'invalid-phone-number':
          return AuthFailure('invalid_phone_number', error.message, trace);
        case 'invalid-photo-url':
          return AuthFailure('invalid_photo_url', error.message, trace);
        case 'invalid-provider-data':
          return AuthFailure('invalid_provider_data', error.message, trace);
        case 'invalid-provider-id':
          return AuthFailure('invalid_provider_id', error.message, trace);
        case 'invalid-oauth-responsetype':
          return AuthFailure(
            'invalid_oauth_response_type',
            error.message,
            trace,
          );
        case 'invalid-session-cookie-duration':
          return AuthFailure(
            'invalid_session_cookie_duration',
            error.message,
            trace,
          );
        case 'invalid-uid':
          return AuthFailure('invalid_uid', error.message, trace);
        case 'invalid-user-import':
          return AuthFailure('invalid_user_import', error.message, trace);
        case 'maximum-user-count-exceeded':
          return AuthFailure(
            'maximum_user_count_exceeded',
            error.message,
            trace,
          );
        case 'missing-android-pkg-name':
          return AuthFailure('missing_android_pkg_name', error.message, trace);
        case 'missing-continue-uri':
          return AuthFailure('missing_continue_uri', error.message, trace);
        case 'missing-hash-algorithm':
          return AuthFailure('missing_hash_algorithm', error.message, trace);
        case 'missing-ios-bundle-id':
          return AuthFailure('missing_ios_bundle_id', error.message, trace);
        case 'missing-uid':
          return AuthFailure('missing_uid', error.message, trace);
        case 'missing-oauth-client-secret':
          return AuthFailure(
            'missing_oauth_client_secret',
            error.message,
            trace,
          );
        case 'operation-not-allowed':
          return AuthFailure('operation_not_allowed', error.message, trace);
        case 'phone-number-already-exists':
          return AuthFailure('phone_number_exists', error.message, trace);
        case 'project-not-found':
          return AuthFailure('project_not_found', error.message, trace);
        case 'reserved-claims':
          return AuthFailure('reserved_claims', error.message, trace);
        case 'session-cookie-expired':
          return AuthFailure('session_cookie_expired', error.message, trace);
        case 'session-cookie-revoked':
          return AuthFailure('session_cookie_revoked', error.message, trace);
        case 'uid-already-exists':
          return AuthFailure('uid_exists', error.message, trace);
        case 'unauthorized-continue-uri':
          return AuthFailure('unauthorized_continue_uri', error.message, trace);
        default:
          return AuthFailure('auth_error', error.message, trace);
      }
    }

    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return ServerFailure('permission_denied', error.message, trace);
      }
      if (error.plugin == 'firebase_database') {
        return ServerFailure('firebase_database_error', error.message, trace);
      }
      if (error.plugin == 'cloud_firestore') {
        return ServerFailure('firestore_error', error.message, trace);
      }
      return ServerFailure('firebase_error', error.message, trace);
    }

    return null;
  }
}
