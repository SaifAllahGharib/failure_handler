abstract class Failure {
  final String code;
  final String? message;
  final StackTrace? stackTrace;

  const Failure(this.code, [this.message, this.stackTrace]);
}

class AuthFailure extends Failure {
  const AuthFailure(super.code, [super.message, super.stackTrace]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.code, [super.message, super.stackTrace]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.code, [super.message, super.stackTrace]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message, StackTrace? stackTrace])
    : super('unknown_error', message, stackTrace);
}
