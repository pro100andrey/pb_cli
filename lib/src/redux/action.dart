part of 'store.dart';

abstract class ReduxAction<St> {
  late Store<St> _store;

  Store<St> get store => _store;
  St get state => _store.state;

  late St _initialState;
  St get initialState => _initialState;

  var _status = const ActionStatus();
  ActionStatus get status => _status;

  bool _completedFuture = false;

  void setStore(Store<St> store) {
    _store = store;
    _initialState = _store.state;
  }

  FutureOr<St?> reduce();

  bool abortDispatch() => false;

  FutureOr<St?> wrapReduce(Reducer<St> reduce) => null;

  Object? wrapError(Object error, StackTrace stackTrace) => error;

  bool ifWrapReduceOverriddenAsync() =>
      wrapReduce is Future<St?> Function(Reducer<St>);

  bool ifWrapReduceOverriddenSync() => wrapReduce is St? Function(Reducer<St>);

  bool ifWrapReduceOverridden() =>
      ifWrapReduceOverriddenAsync() || ifWrapReduceOverriddenSync();

  bool isSync() {
    final reduceMethodIsSync = reduce is St? Function();
    if (!reduceMethodIsSync) {
      return false;
    }

    // `wrapReduce` is sync if it's not overridden.
    // `wrapReduce` is sync if it's overridden and SYNC.
    // `wrapReduce` is NOT sync if it's overridden and ASYNC.
    return !ifWrapReduceOverriddenAsync();
  }

  bool isWaiting(Object actionOrTypeOrList) =>
      _store.isWaiting(actionOrTypeOrList);

  bool isFailed(Object actionOrTypeOrList) =>
      _store.isFailed(actionOrTypeOrList);

  UserException? exceptionFor(Object actionTypeOrList) =>
      _store.exceptionFor(actionTypeOrList);

  void clearExceptionFor(Object actionTypeOrList) =>
      _store.clearExceptionFor(actionTypeOrList);

  /// Returns the runtimeType, without the generic part.
  String runtimeTypeString() {
    final text = runtimeType.toString();
    final pos = text.indexOf('<');
    return (pos == -1) ? text : text.substring(0, pos);
  }

  @override
  String toString() => 'Action ${runtimeTypeString()}';
}

class AbortDispatchException implements Exception {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbortDispatchException && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
