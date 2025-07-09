abstract class AppFailure {
  final String code;
  final String? message;
  final StackTrace? stackTrace;

  const AppFailure(this.code, [this.message, this.stackTrace]);
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.code, [super.message, super.stackTrace]);
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.code, [super.message, super.stackTrace]);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.code, [super.message, super.stackTrace]);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([String? message, StackTrace? stackTrace])
    : super('unknown_error', message, stackTrace);
}
