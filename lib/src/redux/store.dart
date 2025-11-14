import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';

import 'dependencies.dart';
import 'global_wrap_error.dart';
import 'observers.dart';
import 'store_exception.dart';
import 'user_exception.dart';
import 'wrap_reduce.dart';

part 'action.dart';

typedef Reducer<St> = FutureOr<St?> Function();

typedef DispatchAndWait<St> =
    Future<ActionStatus> Function(ReduxAction<St> action, {bool notify});

typedef DispatchSync<St> =
    ActionStatus Function(ReduxAction<St> action, {bool notify});

final class Store<St> {
  Store({
    required St initialState,
    bool syncStream = false,
    List<ActionObserver>? actionObservers,
    List<StateObserver>? stateObservers,
    WrapReduce<St>? wrapReduce,
    GlobalWrapError<St>? globalWrapError,
    ErrorObserver<St>? errorObserver,
  }) : _state = initialState,
       _actionObservers = actionObservers,
       _stateObservers = stateObservers,
       _wrapReduce = wrapReduce,
       _globalWrapError = globalWrapError,
       _errorObserver = errorObserver,
       _changeController = StreamController<St>.broadcast(sync: syncStream),
       _stateTimestamp = DateTime.now().toUtc(),
       _errors = Queue<UserException>(),
       _dependencies = Dependencies(),
       _actionsInProgress = HashSet<ReduxAction<St>>.identity(),
       _actionsWeCanCheckFailed = HashSet<Type>.identity(),
       _failedActions = HashMap<Type, ReduxAction<St>>(),
       _dispatchCount = 0,
       _reduceCount = 0,
       _maxErrorsQueued = 10;

  final StreamController<St> _changeController;
  final List<ActionObserver>? _actionObservers;
  final List<StateObserver>? _stateObservers;
  final WrapReduce<St>? _wrapReduce;
  final GlobalWrapError<St>? _globalWrapError;
  final ErrorObserver<St>? _errorObserver;
  final int _maxErrorsQueued;
  final Queue<UserException> _errors;
  final Dependencies _dependencies;
  final HashSet<ReduxAction<St>> _actionsInProgress;
  final HashMap<Type, ReduxAction<St>> _failedActions;
  final HashSet<Type> _actionsWeCanCheckFailed;

  St _state;
  DateTime _stateTimestamp;
  int _dispatchCount;
  int _reduceCount;

  DateTime get stateTimestamp => _stateTimestamp;
  int get dispatchCount => _dispatchCount;
  int get reduceCount => _reduceCount;
  St get state => _state;
  Dependencies get dependencies => _dependencies;

  Stream<St> get onChange => _changeController.stream;

  static int defaultTimeoutMillis = 60 * 1000 * 10;

  final _stateConditionCompleters =
      <bool Function(St), Completer<ReduxAction<St>?>>{};

  final _awaitableActions = HashSet<Type>.identity();

  final _actionConditionCompleters =
      <
        bool Function(Set<ReduxAction<St>>, ReduxAction<St>?),
        Completer<(Set<ReduxAction<St>>, ReduxAction<St>?)>
      >{};

  ActionStatus dispatchSync(ReduxAction<St> action, {bool notify = true}) {
    if (!action.isSync()) {
      throw StoreException(
        "Can't dispatchSync(${action.runtimeType}) because "
        '${action.runtimeType} is async.',
      );
    }

    return _dispatch(action, notify: notify) as ActionStatus;
  }

  Future<ActionStatus> dispatchAndWait(
    ReduxAction<St> action, {
    bool notify = true,
  }) => Future.sync(() => _dispatch(action, notify: notify));

  FutureOr<ActionStatus> _dispatch(
    ReduxAction<St> action, {
    required bool notify,
  }) {
    // The action may access the store/state/dispatch as fields.
    action.setStore(this);

    if (action.abortDispatch()) {
      return const ActionStatus(isDispatchAborted: true);
    }

    _dispatchCount++;

    if (action.status.isDispatched) {
      throw const StoreException(
        'The action was already dispatched. '
        'Please, create a new action each time.',
      );
    }

    action._status = action._status.copy(isDispatched: true);

    if (_actionObservers != null) {
      for (final observer in _actionObservers) {
        observer.observe(action, dispatchCount, ini: true);
      }
    }

    return _processAction(action, notify: notify);
  }

  Future<void> waitAllActions(
    List<ReduxAction<St>>? actions, {
    bool completeImmediately = false,
    int? timeoutMillis,
  }) {
    if (actions == null || actions.isEmpty) {
      return waitActionCondition(
        completeImmediately: completeImmediately,
        completedErrorMessage: 'No actions were in progress',
        timeoutMillis: timeoutMillis,
        (actions, triggerAction) => actions.isEmpty,
      );
    } else {
      return waitActionCondition(
        completeImmediately: completeImmediately,
        completedErrorMessage: 'None of the given actions were in progress',
        timeoutMillis: timeoutMillis,
        //
        (actionsInProgress, triggerAction) {
          for (final action in actions) {
            if (actionsInProgress.contains(action)) {
              return false;
            }
          }
          return true;
        },
      );
    }
  }

  bool isWaiting(Object actionOrActionTypeOrList) {
    //
    // 1) If a type was passed:
    if (actionOrActionTypeOrList is Type) {
      _awaitableActions.add(actionOrActionTypeOrList);
      return _actionsInProgress.any(
        (action) => action.runtimeType == actionOrActionTypeOrList,
      );
    }
    //
    // 2) If an action was passed:
    else if (actionOrActionTypeOrList is ReduxAction) {
      _awaitableActions.add(actionOrActionTypeOrList.runtimeType);
      return _actionsInProgress.contains(actionOrActionTypeOrList);
    }
    //
    // 3) If an iterable was passed:
    // 3.1) For each action or action type in the iterable...
    else if (actionOrActionTypeOrList is Iterable) {
      var isWaiting = false;
      for (final actionOrType in actionOrActionTypeOrList) {
        //
        // 3.2) If it's a type.
        if (actionOrType is Type) {
          _awaitableActions.add(actionOrType);

          // 3.2.1) Is waiting if any of the actions in progress has that exact
          // type.
          if (!isWaiting) {
            isWaiting = _actionsInProgress.any(
              (action) => action.runtimeType == actionOrType,
            );
          }
        }
        //
        // 3.3) If it's an action.
        else if (actionOrType is ReduxAction) {
          _awaitableActions.add(actionOrType.runtimeType);

          // 3.3.1) Is waiting if any of the actions in progress is the exact
          // action.
          if (!isWaiting) {
            isWaiting = _actionsInProgress.contains(actionOrType);
          }
        }
        //
        // 3.4) If it's not an action and not an action type, throw an
        // exception.
        // The exception is thrown after the async gap, so that it doesn't
        // interrupt the processes.
        else {
          // ignore: discarded_futures
          Future.microtask(() {
            final type = actionOrActionTypeOrList.runtimeType;
            throw StoreException(
              "You can't do isWaiting''([$type]). "
              'Use only actions, action types, or a list of them.',
            );
          });
        }
      }

      // 3.5) If the `for` finished without matching any items, return false
      //(it's NOT waiting).
      return isWaiting;
    }
    // 4) If something different was passed, it's an error. We show the error
    // after the async gap, so we don't interrupt the code. But we return false
    //(not waiting).
    else {
      // ignore: discarded_futures
      Future.microtask(() {
        throw StoreException(
          "You can't do isWaiting(${actionOrActionTypeOrList.runtimeType}), "
          'Use only actions, action types, or a list of them.',
        );
      });

      return false;
    }
  }

  bool isFailed(Object actionOrActionTypeOrList) =>
      exceptionFor(actionOrActionTypeOrList) != null;

  UserException? exceptionFor(Object actionTypeOrList) {
    //
    // 1) If a type was passed:
    if (actionTypeOrList is Type) {
      _actionsWeCanCheckFailed.add(actionTypeOrList);
      final action = _failedActions[actionTypeOrList];
      final error = action?.status.wrappedError;
      return (error is UserException) ? error : null;
    }
    //
    // 2) If a list was passed:
    else if (actionTypeOrList is Iterable) {
      for (final actionType in actionTypeOrList) {
        _actionsWeCanCheckFailed.add(actionType);
        if (actionType is Type) {
          final error = _failedActions.entries
              .firstWhereOrNull((entry) => entry.key == actionType)
              ?.value
              .status
              .wrappedError;
          return (error is UserException) ? error : null;
        } else {
          // ignore: discarded_futures
          Future.microtask(() {
            throw StoreException(
              "You can't do exceptionFor([${actionTypeOrList.runtimeType}]), "
              'but only an action Type, or a List of types.',
            );
          });
        }
      }
      return null;
    }
    // 3) If something different was passed, it's an error. We show the error
    // after the async gap, so we don't interrupt the code. But we return null.
    else {
      // ignore: discarded_futures
      Future.microtask(() {
        throw StoreException(
          "You can't do exceptionFor(${actionTypeOrList.runtimeType}), "
          'but only an action Type, or a List of types.',
        );
      });

      return null;
    }
  }

  void clearExceptionFor(Object actionTypeOrList) {
    //
    // 1) If a type was passed:
    if (actionTypeOrList is Type) {
      final result = _failedActions.remove(actionTypeOrList);
      if (result != null) {
        _changeController.add(state);
      }
    }
    //
    // 2) If a list was passed:
    else if (actionTypeOrList is Iterable) {
      Object? result;
      for (final actionType in actionTypeOrList) {
        if (actionType is Type) {
          result = _failedActions.remove(actionType);
        } else {
          // ignore: discarded_futures
          Future.microtask(() {
            throw StoreException(
              "You can't clearExceptionFor([${actionTypeOrList.runtimeType}]), "
              'but only an action Type, or a List of types.',
            );
          });
        }
      }
      if (result != null) {
        _changeController.add(state);
      }
    }
    // 3) If something different was passed, it's an error. We show the error
    // after the async gap, so we don't interrupt the code. But we return null.
    else {
      // ignore: discarded_futures
      Future.microtask(() {
        throw StoreException(
          "You can't clearExceptionFor(${actionTypeOrList.runtimeType}), "
          'but only an action Type, or a List of types.',
        );
      });
    }
  }

  Future<ReduxAction<St>?> waitCondition(
    bool Function(St) condition, {
    bool completeImmediately = true,
    int? timeoutMillis,
  }) async {
    //
    // If the condition is already true when `waitCondition` is called.
    if (condition(_state)) {
      // Complete and return null (no trigger action).
      if (completeImmediately) {
        return Future.syncValue(null);
      } else {
        throw const StoreException(
          'Awaited state condition was already true, '
          'and the future completed immediately.',
        );
      }
    }
    //
    else {
      final completer = Completer<ReduxAction<St>?>();

      _stateConditionCompleters[condition] = completer;

      final timeout = timeoutMillis ?? defaultTimeoutMillis;
      var future = completer.future;

      if (timeout >= 0) {
        future = completer.future.timeout(
          Duration(milliseconds: timeout),
          onTimeout: () {
            _stateConditionCompleters.remove(condition);
            throw TimeoutException(null, Duration(milliseconds: timeout));
          },
        );
      }

      return future;
    }
  }

  FutureOr<ActionStatus> _processAction(
    ReduxAction<St> action, {
    bool notify = true,
  }) {
    _calculateIsWaitingIsFailed(action);

    if (action.isSync()) {
      return _processActionSync(action, notify: notify);
    } else {
      return _processActionAsync(action, notify: notify);
    }
  }

  void _calculateIsWaitingIsFailed(ReduxAction<St> action) {
    // If the action is fallible (that is to say, we have once called `isFailed`
    // for this action),
    final fallible = _actionsWeCanCheckFailed.contains(action.runtimeType);

    var theUIHasAlreadyUpdated = false;

    if (fallible) {
      // Dispatch is starting, so we remove the action from the list of failed
      // actions.
      final removedAction = _failedActions.remove(action.runtimeType);

      // Then we notify the UI. Note we don't notify if the action was never
      // checked.
      if (removedAction != null) {
        theUIHasAlreadyUpdated = true;
        _changeController.add(state);
      }
    }

    // Add the action to the list of actions in progress.
    // Note: We add both SYNC and ASYNC actions. The SYNC actions are important
    // too, to prevent NonReentrant sync actions, where they call themselves.
    final ifWasAdded = _actionsInProgress.add(action);
    if (ifWasAdded) {
      _checkAllActionConditions(action);
    }

    // Note: If the UI hasn't updated yet, AND
    // the action is awaitable (that is to say, we have already called
    //`isWaiting` for this action),
    if (!theUIHasAlreadyUpdated &&
        _awaitableActions.contains(action.runtimeType)) {
      _changeController.add(state);
    }
  }

  ActionStatus _processActionSync(
    ReduxAction<St> action, {
    bool notify = true,
  }) {
    // The action may access the store/state/dispatch as fields.
    assert(
      action.store == this,
      'The action.store is not set to the correct store instance.',
    );

    Object? originalError;
    Object? processedError;

    try {
      // ignore: discarded_futures
      _applyReducer(action, notify: notify);
      action._status = action._status.copy(hasFinishedMethodReduce: true);
    }
    //
    catch (error, stackTrace) {
      originalError = error;
      processedError = _processError(action, error, stackTrace);

      // Error is meant to be "swallowed".
      if (processedError == null) {
        return action._status;
      } else if (identical(processedError, error)) {
        rethrow;
      }
      //
      // Error was wrapped. Throw.
      else {
        Error.throwWithStackTrace(processedError, stackTrace);
      }
    }
    //
    finally {
      _finalize(action, originalError, processedError, notify);
    }

    return action._status;
  }

  FutureOr<void> _applyReducer(ReduxAction<St> action, {bool notify = true}) {
    _reduceCount++;

    // Make sure the action reducer returns an acceptable type.
    _checkReducerType(action.reduce);

    if (action.ifWrapReduceOverridden()) {
      return _applyReduceAndWrapReduce(action, notify: notify);
    } else {
      return _applyReduce(action, notify: notify);
    }
  }

  FutureOr<void> _applyReduceAndWrapReduce(
    ReduxAction<St> action, {
    bool notify = true,
  }) {
    assert(
      action.ifWrapReduceOverridden(),
      'This method should only be called when wrapReduce is overridden.',
    );

    if (action.ifWrapReduceOverriddenSync()) {
      throw StoreException(
        'The ${action.runtimeType}.wrapReduce method '
        'should return `Future<St?>`, not `<St>` or `<St?>`.',
      );
    }

    action._completedFuture = false;

    final reduce = (_wrapReduce != null)
        ? _wrapReduce.wrapReduce(action.reduce, this)
        : action.reduce;

    return (action.wrapReduce(reduce) as Future<St?>?)!.then((state) {
      _registerState(state, action, notify: notify);

      if (action._completedFuture) {
        return Future.error(
          'The reducer of action ${action.runtimeType} returned a completed '
          'Future. This may result in state changes being lost. '
          'Please make sure all code paths in the reducer pass through at '
          'least one `await`. If necessary, add `await microtask;` to the '
          'start of the reducer.',
        );
      }
    });
  }

  FutureOr<void> _applyReduce(ReduxAction<St> action, {bool notify = true}) {
    final reduce = (_wrapReduce != null)
        ? _wrapReduce.wrapReduce(action.reduce, this)
        : action.reduce;

    // Sync reducer.
    if (reduce is St? Function()) {
      _registerState(reduce(), action, notify: notify);
    }
    // Async reducer.
    else if (reduce is Future<St?> Function()) {
      action._completedFuture = false;

      return reduce().then((state) {
        _registerState(state, action, notify: notify);

        if (action._completedFuture) {
          {
            return Future.error(
              'The reducer of action ${action.runtimeType} returned a '
              'completed Future. This may result in state changes being lost. '
              'Please make sure all code paths in the reducer pass through at '
              'least one `await`. If necessary, add `await microtask;` to the '
              'start of the reducer.',
            );
          }
        }
      });
    }
    // Invalid reducer (FutureOr is not accepted).
    else {
      throw StoreException(
        'Reducer should return `St?` or `Future<St?>`. '
        'Do not return `FutureOr<St?>`. '
        "Reduce is of type: '${reduce.runtimeType}'.",
      );
    }
  }

  /// We check the return type of methods `before` and `reduce` to decide if the
  /// reducer is synchronous or asynchronous. It's important to run the reducer
  /// synchronously, if possible.
  Future<ActionStatus> _processActionAsync(
    ReduxAction<St> action, {
    bool notify = true,
  }) async {
    // The action may access the store/state/dispatch as fields.
    assert(
      action.store == this,
      'The action.store is not set to the correct store instance.',
    );

    Object? result;
    Object? originalError;
    Object? processedError;

    try {
      if (result is Future) {
        await result;
      }

      result = _applyReducer(action, notify: notify);
      if (result is Future) {
        await result;
      }

      action._status = action._status.copy(hasFinishedMethodReduce: true);
    }
    //
    catch (error, stackTrace) {
      originalError = error;
      processedError = _processError(action, error, stackTrace);
      // Error is meant to be "swallowed".
      if (processedError == null) {
        return action._status;
      } else if (identical(processedError, error)) {
        rethrow;
      } else {
        Error.throwWithStackTrace(processedError, stackTrace);
      }
    }
    //
    finally {
      _finalize(action, originalError, processedError, notify);
    }

    return action._status;
  }

  void _checkAllActionConditions(ReduxAction<St> triggerAction) {
    final keysToRemove =
        <bool Function(Set<ReduxAction<St>>, ReduxAction<St>?)>[];

    _actionConditionCompleters.forEach((condition, completer) {
      final actionsInProgress = UnmodifiableSetView(_actionsInProgress);

      if (condition(actionsInProgress, triggerAction)) {
        completer.complete((actionsInProgress, triggerAction));
        keysToRemove.add(condition);
      }
    });

    keysToRemove.forEach(_actionConditionCompleters.remove);
  }

  Future<(Set<ReduxAction<St>>, ReduxAction<St>?)> waitActionCondition(
    bool Function(Set<ReduxAction<St>> actions, ReduxAction<St>? triggerAction)
    condition, {
    bool completeImmediately = false,
    String completedErrorMessage = 'Awaited action condition was already true',
    int? timeoutMillis,
  }) {
    final actionsInProgress = UnmodifiableSetView(_actionsInProgress);

    if (condition(actionsInProgress, null)) {
      // Complete and return the actions in progress and the trigger action.
      if (completeImmediately) {
        return Future.syncValue((actionsInProgress, null));
      } else {
        throw StoreException(
          '$completedErrorMessage, and the future completed immediately.',
        );
      }
    }
    //
    else {
      final completer = Completer<(Set<ReduxAction<St>>, ReduxAction<St>?)>();

      _actionConditionCompleters[condition] = completer;

      final timeout = timeoutMillis ?? defaultTimeoutMillis;
      var future = completer.future;

      if (timeout >= 0) {
        future = completer.future.timeout(
          Duration(milliseconds: timeout),
          onTimeout: () {
            _actionConditionCompleters.remove(condition);
            throw TimeoutException(null, Duration(milliseconds: timeout));
          },
        );
      }

      return future;
    }
  }

  void _checkReducerType(FutureOr<St?> Function() reduce) {
    //
    // Sync reducer is acceptable.
    if (reduce is St? Function()) {
      return;
    }
    //
    // Async reducer is acceptable.
    else if (reduce is Future<St?> Function()) {
      return;
    }
    //
    else if (reduce is Future<St>? Function()) {
      throw const StoreException(
        '${_reducerTypeErrorMsg}Do not return `Future<St>?`.',
      );
    }
    //
    else if (reduce is Future<St?>? Function()) {
      throw const StoreException(
        '${_reducerTypeErrorMsg}Do not return `Future<St?>?`.',
      );
    }
    //
    // ignore: unnecessary_type_check
    else if (reduce is FutureOr Function()) {
      throw const StoreException(
        '${_reducerTypeErrorMsg}Do not return `FutureOr`.',
      );
    }
  }

  static const _reducerTypeErrorMsg =
      'Reducer should return `St?` or `Future<St?>`. ';

  /// Returns the processed error. Returns `null` if the error is meant to be
  /// "swallowed".
  Object? _processError(
    ReduxAction<St> action,
    Object error,
    StackTrace stackTrace,
  ) {
    if (_stateObservers != null) {
      for (final observer in _stateObservers) {
        observer.observe(action, _state, _state, error, dispatchCount);
      }
    }

    Object? errorOrNull = error;

    action._status = action._status.copy(originalError: error);

    try {
      errorOrNull = action.wrapError(errorOrNull, stackTrace);
    } on Object catch (e) {
      // If the action's wrapError throws an error, it will be used instead
      // of the original error (but the recommended way is returning the error).
      errorOrNull = e;
    }

    if (_globalWrapError != null && errorOrNull != null) {
      try {
        errorOrNull = _globalWrapError.wrap(errorOrNull, stackTrace, action);
      } on Object catch (e) {
        // If the GlobalWrapError throws an error, it will be used instead
        // of the original error (but the recommended way is returning the
        // error).
        errorOrNull = e;
      }
    }

    action._status = action._status.copy(wrappedError: errorOrNull);

    // Memorizes the action that failed. We'll remove it when it's dispatched
    // again.
    _failedActions[action.runtimeType] = action;

    // Memorizes errors of type UserException (in the error queue).
    // These errors are usually shown to the user in a modal dialog, and are
    //not logged.
    if (errorOrNull is UserException) {
      if (errorOrNull.ifOpenDialog) {
        _addError(errorOrNull);
        _changeController.add(state);
      }
    } else if (errorOrNull is AbortDispatchException) {
      action._status = action._status.copy(isDispatchAborted: true);
    }

    // If an errorObserver was NOT defined, return (to throw) all errors which
    // are not UserException or AbortDispatchException.
    if (_errorObserver == null) {
      if ((errorOrNull is! UserException) &&
          (errorOrNull is! AbortDispatchException)) {
        return errorOrNull;
      }
    }
    // If an errorObserver was defined, observe the error.
    // Then, if the observer returns true, return the error to be thrown.
    else if (errorOrNull != null) {
      try {
        if (_errorObserver.observe(errorOrNull, stackTrace, action, this)) {
          return errorOrNull;
        }
      } on Object catch (e) {
        // The errorObserver should never throw. However, if it does, print the
        // error.
        _throws(
          "Method 'ErrorObserver.observe()' has thrown an error '$e' "
          "when observing error '$errorOrNull'.",
          e,
          stackTrace,
        );

        return errorOrNull;
      }
    }

    return null;
  }

  void _throws(errorMsg, Object? error, StackTrace stackTrace) {
    // ignore: discarded_futures
    Future(() {
      Error.throwWithStackTrace(
        (error == null) ? errorMsg : '$errorMsg:\n  $error',
        stackTrace,
      );
    });
  }

  /// Adds an error at the end of the error queue.
  void _addError(UserException error) {
    if (_errors.length > _maxErrorsQueued) {
      _errors.removeFirst();
    }

    _errors.addLast(error);
  }

  void _finalize(
    ReduxAction<St> action,
    Object? error,
    Object? processedError,
    bool notify,
  ) {
    final ifWasRemoved = _actionsInProgress.remove(action);
    if (ifWasRemoved) {
      _checkAllActionConditions(action);
    }

    // If we'll not be notifying, it's possible we need to trigger the change
    // controller, when the action is awaitable (that is to say, when we have
    // already called `isWaiting` for this action).
    if (_awaitableActions.contains(action.runtimeType) &&
        ((error != null) || !notify)) {
      _changeController.add(state);
    }

    if (_actionObservers != null) {
      for (final observer in _actionObservers) {
        observer.observe(action, dispatchCount, ini: false);
      }
    }
  }

  void _registerState(
    St? state,
    ReduxAction<St> action, {
    bool notify = true,
  }) {
    final prevState = _state;

    // Reducers may return null state, or the unaltered state, when they don't
    // want to change the state. Note: If the action is an "active action" it
    // will be removed, so we have to add the state to _changeController even
    // if it's the same state.
    if (((state != null) && !identical(_state, state)) ||
        _actionsInProgress.contains(action)) {
      _state = state ?? _state;
      _stateTimestamp = DateTime.now().toUtc();

      if (notify) {
        _changeController.add(state ?? _state);
      }

      _checkAllStateConditions(action);
    }
    final newState = _state;

    if (_stateObservers != null) {
      for (final observer in _stateObservers) {
        observer.observe(action, prevState, newState, null, dispatchCount);
      }
    }
  }

  void _checkAllStateConditions(ReduxAction<St> triggerAction) {
    final keysToRemove = <bool Function(St)>[];

    _stateConditionCompleters.forEach((condition, completer) {
      if (condition(_state)) {
        completer.complete(triggerAction);
        keysToRemove.add(condition);
      }
    });

    keysToRemove.forEach(_stateConditionCompleters.remove);
  }
}

final class ActionStatus {
  const ActionStatus({
    this.isDispatched = false,
    this.hasFinishedMethodReduce = false,
    this.isDispatchAborted = false,
    this.originalError,
    this.wrappedError,
  });

  final bool isDispatched;
  final bool hasFinishedMethodReduce;
  final bool isDispatchAborted;
  final Object? originalError;
  final Object? wrappedError;

  bool get isCompletedOk => isCompleted && (originalError == null);
  bool get isCompletedFailed => isCompleted && (originalError != null);
  bool get isCompleted => hasFinishedMethodReduce || isDispatchAborted;

  ActionStatus copy({
    bool? isDispatched,
    bool? hasFinishedMethodReduce,
    bool? isDispatchAborted,
    Object? originalError,
    Object? wrappedError,
  }) => ActionStatus(
    isDispatched: isDispatched ?? this.isDispatched,
    hasFinishedMethodReduce:
        hasFinishedMethodReduce ?? this.hasFinishedMethodReduce,
    isDispatchAborted: isDispatchAborted ?? this.isDispatchAborted,
    originalError: originalError ?? this.originalError,
    wrappedError: wrappedError ?? this.wrappedError,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionStatus &&
          runtimeType == other.runtimeType &&
          isDispatched == other.isDispatched &&
          hasFinishedMethodReduce == other.hasFinishedMethodReduce &&
          isDispatchAborted == other.isDispatchAborted &&
          originalError == other.originalError &&
          wrappedError == other.wrappedError;

  @override
  int get hashCode =>
      isDispatched.hashCode ^
      hasFinishedMethodReduce.hashCode ^
      isDispatchAborted.hashCode ^
      originalError.hashCode ^
      wrappedError.hashCode;
}
