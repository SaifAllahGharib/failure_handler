import '../../failure_handler.dart';

typedef StreamResult<T> = Stream<Result<AppFailure, T>>;
