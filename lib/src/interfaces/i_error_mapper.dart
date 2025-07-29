import '../../failure_handler.dart';

abstract class IErrorMapper {
  AppFailure? tryHandle(dynamic error, [StackTrace? stackTrace]);
}
