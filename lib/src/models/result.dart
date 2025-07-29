abstract class Result<F, S> {
  const Result();

  T when<T>({
    required T Function(F failure) failure,
    required T Function(S success) success,
  });
}

class Failure<F, S> extends Result<F, S> {
  final F value;

  const Failure(this.value);

  @override
  T when<T>({
    required T Function(F failure) failure,
    required T Function(S success) success,
  }) {
    return failure(value);
  }
}

class Success<F, S> extends Result<F, S> {
  final S value;

  const Success(this.value);

  @override
  T when<T>({
    required T Function(F failure) failure,
    required T Function(S success) success,
  }) {
    return success(value);
  }
}
