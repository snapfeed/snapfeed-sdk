abstract class SnapfeedDataState<T> {
  SnapfeedDataState();

  factory SnapfeedDataState.idle() => Idle<T>();

  factory SnapfeedDataState.loading() => Loading<T>();

  factory SnapfeedDataState.success(T response) => Success<T>(response);

  factory SnapfeedDataState.error(dynamic exception) =>
      UncaughtException<T>(exception);

  bool get isIdle => this is Idle;

  bool get isLoading => this is Loading;

  bool get isIdleOrLoading => this is Idle || this is Loading;

  bool get isSuccess => this is Success;

  Success<T> get success => this is Success ? this as Success<T> : null;

  bool get isError => this is UncaughtException;

  UncaughtException<T> get error =>
      this is UncaughtException ? this as UncaughtException<T> : null;
}

class Idle<T> extends SnapfeedDataState<T> {
  Idle();
}

class Loading<T> extends SnapfeedDataState<T> {
  Loading();
}

class Success<T> extends SnapfeedDataState<T> {
  Success(this.response);

  final T response;
}

class UncaughtException<T> extends SnapfeedDataState<T> {
  UncaughtException(this.exception);

  final dynamic exception;
}
