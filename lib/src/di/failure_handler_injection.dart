import 'package:failure_handler/src/error_logger.dart';
import 'package:get_it/get_it.dart';

import '../../failure_handler.dart';
import '../interfaces/i_error_mapper.dart';
import '../mappers/default_error_mapper.dart';
import '../mappers/dio_error_mapper.dart';
import '../mappers/firebase_error_mapper.dart';
import '../mappers/supabase_error_mapper.dart';

final getIt = GetIt.instance;

void registerFailureHandlerDependencies() {
  getIt.registerLazySingleton<IErrorMapper>(
    () => const DioErrorMapper(),
    instanceName: 'dio',
  );
  getIt.registerLazySingleton<IErrorMapper>(
    () => const FirebaseErrorMapper(),
    instanceName: 'firebase',
  );
  getIt.registerLazySingleton<IErrorMapper>(
    () => const SupabaseErrorMapper(),
    instanceName: 'supabase',
  );
  getIt.registerLazySingleton<IErrorMapper>(
    () => const DefaultErrorMapper(),
    instanceName: 'default',
  );

  getIt.registerLazySingleton(() => ErrorLogger());

  getIt.registerLazySingleton<ErrorHandler>(
    () => ErrorHandler([
      getIt<IErrorMapper>(instanceName: 'dio'),
      getIt<IErrorMapper>(instanceName: 'firebase'),
      getIt<IErrorMapper>(instanceName: 'supabase'),
      getIt<IErrorMapper>(instanceName: 'default'),
    ], getIt()),
  );
}
