import '../../failure_handler.dart';

abstract class IErrorMapper {
  bool canHandle(dynamic error);

  AppFailure handle(dynamic error);
}
