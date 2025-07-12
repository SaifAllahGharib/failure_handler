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
        case 'email-already-exists':
          return AuthFailure('email_in_use', error.message, StackTrace.current);
        case 'invalid-email':
          return AuthFailure(
            'invalid_email',
            error.message,
            StackTrace.current,
          );
        case 'invalid-email-verified':
          return AuthFailure(
            'invalid_email_verified',
            error.message,
            StackTrace.current,
          );
        case 'too-many-requests':
          return AuthFailure(
            'too_many_requests',
            error.message,
            StackTrace.current,
          );
        case 'id-token-expired':
          return AuthFailure(
            'id_token_expired',
            error.message,
            StackTrace.current,
          );
        case 'id-token-revoked':
          return AuthFailure(
            'id_token_revoked',
            error.message,
            StackTrace.current,
          );
        case 'insufficient-permission':
          return AuthFailure(
            'insufficient_permission',
            error.message,
            StackTrace.current,
          );
        case 'internal-error':
          return AuthFailure(
            'internal_error',
            error.message,
            StackTrace.current,
          );
        case 'invalid-argument':
          return AuthFailure(
            'invalid_argument',
            error.message,
            StackTrace.current,
          );
        case 'invalid-claims':
          return AuthFailure(
            'invalid_claims',
            error.message,
            StackTrace.current,
          );
        case 'claims-too-large':
          return AuthFailure(
            'claims_too_large',
            error.message,
            StackTrace.current,
          );
        case 'invalid-continue-uri':
          return AuthFailure(
            'invalid_continue_uri',
            error.message,
            StackTrace.current,
          );
        case 'invalid-creation-time':
          return AuthFailure(
            'invalid_creation_time',
            error.message,
            StackTrace.current,
          );
        case 'invalid-credential':
          return AuthFailure(
            'invalid_credential',
            error.message,
            StackTrace.current,
          );
        case 'invalid-disabled-field':
          return AuthFailure(
            'invalid_disabled_field',
            error.message,
            StackTrace.current,
          );
        case 'invalid-display-name':
          return AuthFailure(
            'invalid_display_name',
            error.message,
            StackTrace.current,
          );
        case 'invalid-dynamic-link-domain':
          return AuthFailure(
            'invalid_dynamic_link_domain',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-algorithm':
          return AuthFailure(
            'invalid_hash_algorithm',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-block-size':
          return AuthFailure(
            'invalid_hash_block_size',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-derived-key-length':
          return AuthFailure(
            'invalid_hash_derived_key_length',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-key':
          return AuthFailure(
            'invalid_hash_key',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-memory-cost':
          return AuthFailure(
            'invalid_hash_memory_cost',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-parallelization':
          return AuthFailure(
            'invalid_hash_parallelization',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-rounds':
          return AuthFailure(
            'invalid_hash_rounds',
            error.message,
            StackTrace.current,
          );
        case 'invalid-hash-salt-separator':
          return AuthFailure(
            'invalid_hash_salt_separator',
            error.message,
            StackTrace.current,
          );
        case 'invalid-id-token':
          return AuthFailure(
            'invalid_id_token',
            error.message,
            StackTrace.current,
          );
        case 'invalid-last-sign-in-time':
          return AuthFailure(
            'invalid_last_sign_in_time',
            error.message,
            StackTrace.current,
          );
        case 'invalid-page-token':
          return AuthFailure(
            'invalid_page_token',
            error.message,
            StackTrace.current,
          );
        case 'invalid-password':
          return AuthFailure(
            'invalid_password',
            error.message,
            StackTrace.current,
          );
        case 'invalid-password-hash':
          return AuthFailure(
            'invalid_password_hash',
            error.message,
            StackTrace.current,
          );
        case 'invalid-password-salt':
          return AuthFailure(
            'invalid_password_salt',
            error.message,
            StackTrace.current,
          );
        case 'invalid-phone-number':
          return AuthFailure(
            'invalid_phone_number',
            error.message,
            StackTrace.current,
          );
        case 'invalid-photo-url':
          return AuthFailure(
            'invalid_photo_url',
            error.message,
            StackTrace.current,
          );
        case 'invalid-provider-data':
          return AuthFailure(
            'invalid_provider_data',
            error.message,
            StackTrace.current,
          );
        case 'invalid-provider-id':
          return AuthFailure(
            'invalid_provider_id',
            error.message,
            StackTrace.current,
          );
        case 'invalid-oauth-responsetype':
          return AuthFailure(
            'invalid_oauth_response_type',
            error.message,
            StackTrace.current,
          );
        case 'invalid-session-cookie-duration':
          return AuthFailure(
            'invalid_session_cookie_duration',
            error.message,
            StackTrace.current,
          );
        case 'invalid-uid':
          return AuthFailure('invalid_uid', error.message, StackTrace.current);
        case 'invalid-user-import':
          return AuthFailure(
            'invalid_user_import',
            error.message,
            StackTrace.current,
          );
        case 'maximum-user-count-exceeded':
          return AuthFailure(
            'maximum_user_count_exceeded',
            error.message,
            StackTrace.current,
          );
        case 'missing-android-pkg-name':
          return AuthFailure(
            'missing_android_pkg_name',
            error.message,
            StackTrace.current,
          );
        case 'missing-continue-uri':
          return AuthFailure(
            'missing_continue_uri',
            error.message,
            StackTrace.current,
          );
        case 'missing-hash-algorithm':
          return AuthFailure(
            'missing_hash_algorithm',
            error.message,
            StackTrace.current,
          );
        case 'missing-ios-bundle-id':
          return AuthFailure(
            'missing_ios_bundle_id',
            error.message,
            StackTrace.current,
          );
        case 'missing-uid':
          return AuthFailure('missing_uid', error.message, StackTrace.current);
        case 'missing-oauth-client-secret':
          return AuthFailure(
            'missing_oauth_client_secret',
            error.message,
            StackTrace.current,
          );
        case 'operation-not-allowed':
          return AuthFailure(
            'operation_not_allowed',
            error.message,
            StackTrace.current,
          );
        case 'phone-number-already-exists':
          return AuthFailure(
            'phone_number_exists',
            error.message,
            StackTrace.current,
          );
        case 'project-not-found':
          return AuthFailure(
            'project_not_found',
            error.message,
            StackTrace.current,
          );
        case 'reserved-claims':
          return AuthFailure(
            'reserved_claims',
            error.message,
            StackTrace.current,
          );
        case 'session-cookie-expired':
          return AuthFailure(
            'session_cookie_expired',
            error.message,
            StackTrace.current,
          );
        case 'session-cookie-revoked':
          return AuthFailure(
            'session_cookie_revoked',
            error.message,
            StackTrace.current,
          );
        case 'uid-already-exists':
          return AuthFailure('uid_exists', error.message, StackTrace.current);
        case 'unauthorized-continue-uri':
          return AuthFailure(
            'unauthorized_continue_uri',
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
