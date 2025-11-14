// ignore_for_file: one_member_abstracts

import 'store.dart';

abstract class ActionObserver<St> {
  const ActionObserver();

  void observe(
    ReduxAction<St> action,
    int dispatchCount, {
    required bool ini,
  });
}

abstract class ErrorObserver<St> {
  const ErrorObserver();
  bool observe(
    Object error,
    StackTrace stackTrace,
    ReduxAction<St> action,
    Store<St> store,
  );
}

abstract class StateObserver<St> {
  const StateObserver();
  void observe(
    ReduxAction<St> action,
    St prevState,
    St newState,
    Object? error,
    int dispatchCount,
  );
}
