import 'package:failure_handler/src/error_logger.dart';
import 'package:get_it/get_it.dart';

import '../../failure_handler.dart';
import '../interfaces/i_error_mapper.dart';
import '../mappers/default_error_mapper.dart';
import '../mappers/dio_error_mapper.dart';
import '../mappers/firebase_error_mapper.dart';
import '../mappers/supabase_error_mapper.dart';

final errorHandlerGetIt = GetIt.instance;

void registerFailureHandlerDependencies() {
  errorHandlerGetIt.registerLazySingleton<IErrorMapper>(
    () => const DioErrorMapper(),
    instanceName: 'dio',
  );
  errorHandlerGetIt.registerLazySingleton<IErrorMapper>(
    () => const FirebaseErrorMapper(),
    instanceName: 'firebase',
  );
  errorHandlerGetIt.registerLazySingleton<IErrorMapper>(
    () => const SupabaseErrorMapper(),
    instanceName: 'supabase',
  );
  errorHandlerGetIt.registerLazySingleton<IErrorMapper>(
    () => const DefaultErrorMapper(),
    instanceName: 'default',
  );

  errorHandlerGetIt.registerLazySingleton(() => ErrorLogger());

  errorHandlerGetIt.registerLazySingleton<ErrorHandler>(
    () => ErrorHandler([
      errorHandlerGetIt<IErrorMapper>(instanceName: 'dio'),
      errorHandlerGetIt<IErrorMapper>(instanceName: 'firebase'),
      errorHandlerGetIt<IErrorMapper>(instanceName: 'supabase'),
      errorHandlerGetIt<IErrorMapper>(instanceName: 'default'),
    ], errorHandlerGetIt()),
  );
}
