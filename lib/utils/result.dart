sealed class Result<T> {
  const Result();

  factory Result.success(T value) = Success<T>;
  factory Result.failure(String message) = Failure;

  bool get isFailure => this is Failure;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  Result<R> map<R>(R Function(T value) fn) => switch (this) {
    Success(:final value) => Success(fn(value)),
    Failure(:final message) => Failure(message),
  };

  R fold<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) => switch (this) {
    Success(:final value) => success(value),
    Failure(:final message) => failure(message),
  };
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Failure extends Result<Never> {
  final String message;
  const Failure(this.message);
}
