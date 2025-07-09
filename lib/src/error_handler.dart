import 'interfaces/i_error_mapper.dart';
import 'mappers/default_error_mapper.dart';
import 'mappers/dio_error_mapper.dart';
import 'mappers/firebase_error_mapper.dart';
import 'mappers/supabase_error_mapper.dart';
import 'models/app_failure.dart';

class ErrorHandler {
  static final List<IErrorMapper> _mappers = [
    DioErrorMapper(),
    FirebaseErrorMapper(),
    SupabaseErrorMapper(),
    DefaultErrorMapper(),
  ];

  static AppFailure handle(dynamic error) {
    for (final mapper in _mappers) {
      if (mapper.canHandle(error)) {
        return mapper.handle(error);
      }
    }

    return UnknownFailure(error.toString(), StackTrace.current);
  }
}
