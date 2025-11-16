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

  DispatchAndWait<St> get dispatchAndWait => _store.dispatchAndWait;

  Dispatch<St> get dispatch => _store.dispatch;

  DispatchSync<St> get dispatchSync => _store.dispatchSync;

  List<ReduxAction<St>> Function(List<ReduxAction<St>> actions, {bool notify})
  get dispatchAll => _store.dispatchAll;

  Future<List<ReduxAction<St>>> Function(
    List<ReduxAction<St>> actions, {
    bool notify,
  })
  get dispatchAndWaitAll => _store.dispatchAndWaitAll;

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

  /// Returns the [UserException] of the [actionTypeOrList] that failed.
  ///
  /// [actionTypeOrList] can be a [Type], or an Iterable of types. Any other
  /// type of object will return null and throw a [StoreException] after the
  /// async gap.
  ///
  /// Note: This method uses the EXACT type in [actionTypeOrList]. Subtypes are
  /// not considered.
  UserException? exceptionFor(Object actionTypeOrList) =>
      _store.exceptionFor(actionTypeOrList);

  /// Removes the given [actionTypeOrList] from the list of action types that
  /// failed.
  ///
  /// Note that dispatching an action already removes that action type from the
  /// exceptions list. This removal happens as soon as the action is dispatched,
  ///  not when it finishes.
  ///
  /// [actionTypeOrList] can be a [Type], or an Iterable of types. Any other
  /// type of object will return null and throw a [StoreException] after the
  /// async gap.
  ///
  /// Note: This method uses the EXACT type in [actionTypeOrList]. Subtypes are
  /// not considered.
  void clearExceptionFor(Object actionTypeOrList) =>
      _store.clearExceptionFor(actionTypeOrList);

  /// Returns a future which will complete when the given state [condition] is
  /// true. If the condition is already true when the method is called, the
  /// future completes immediately.
  ///
  /// You may also provide a [timeoutMillis], which by default is 10 minutes.
  /// To disable the timeout, make it -1.
  /// If you want, you can modify [Store.defaultTimeoutMillis] to change the
  /// default timeout.
  ///
  /// ```dart
  /// var action = await store.waitCondition((state) => state.name == "Bill");
  /// expect(action, isA<ChangeNameAction>());
  /// ```
  Future<ReduxAction<St>?> waitCondition(
    bool Function(St) condition, {
    int? timeoutMillis,
  }) => _store.waitCondition(condition, timeoutMillis: timeoutMillis);

  /// Returns a future that completes when ALL given [actions] finished
  /// dispatching. You MUST provide at list one action, or an error will be
  /// thrown.
  ///
  /// If [completeImmediately] is `false` (the default), this method will throw
  /// [StoreException]  if none of the given actions are in progress when the
  /// method is called. Otherwise, the future will complete immediately and
  /// throw no error.
  Future<void> waitAllActions(
    List<ReduxAction<St>> actions, {
    bool completeImmediately = false,
  }) {
    if (actions.isEmpty) {
      throw const StoreException(
        'You have to provide a non-empty list of actions.',
      );
    }
    return _store.waitAllActions(
      actions,
      completeImmediately: completeImmediately,
    );
  }

  /// An async reducer (one that returns Future<AppState?>) must never complete
  /// without at least one await, because this may result in state changes being
  /// lost. It's up to you to make sure all code paths in the reducer pass
  /// through at least one `await`.
  ///
  /// Futures defined by async functions with no `await` are called "completed
  /// futures". It's generally easy to make sure an async reducer does not
  /// return a completed future. In the rare case when your reducer function is
  /// complex and you are unsure that all code paths pass through an await,
  /// there are 3 possible solutions:
  ///
  ///
  /// * Simplify your reducer, by applying clean-code techniques. That will make
  ///  it easier for you to make sure all code paths have 'await'.
  ///
  /// * Add `await microtask;` to the very START of the reducer.
  ///
  /// * Call method [assertUncompletedFuture] at the very END of your [reduce]
  /// method, right before the return. If you do that, an error will be shown in
  /// the console in case the reduce method ever returns a completed future.
  /// Note there is no other way for AsyncRedux to warn you if your reducer
  /// returned a completed future, because although the completion information
  /// exists in the `FutureImpl` class, it's not exposed. Also note, the error
  /// will be thrown asynchronously (will not stop the action from returning a
  /// state).
  void assertUncompletedFuture() {
    scheduleMicrotask(() {
      _completedFuture = true;
    });
  }

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
