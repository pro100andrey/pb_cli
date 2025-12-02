import 'store.dart';
import 'store_exception.dart';

/// Interface for wrapping the reducer.
///
/// This allows you to add logic that runs before or after the reducer,
/// or to modify the state returned by the reducer.
abstract class WrapReduce<St> {
  /// Returns true if [process] should be called.
  bool ifShouldProcess() => true;

  /// Processes the state change.
  ///
  /// [oldState] is the state before the reducer ran.
  /// [newState] is the state returned by the reducer.
  ///
  /// Returns the new state to be saved in the store.
  St process({required St oldState, required St newState});

  /// Wraps the given [reduce] function.
  /// 
  /// The [store] is provided for context.
  /// Returns a new reducer function that includes the wrapping logic.
  Reducer<St> wrapReduce(Reducer<St> reduce, Store<St> store) {
    if (!ifShouldProcess()) {
      return reduce;
    }
    // 1) Sync reducer.
    else {
      if (reduce is St? Function()) {
        return () {
          // The old-state right before calling the sync reducer.
          final oldState = store.state;

          // This is the state returned by the reducer.
          final newState = reduce();

          // If the reducer returned null, or the same instance, do nothing.
          if (newState == null || identical(store.state, newState)) {
            return newState;
          }

          return process(oldState: oldState, newState: newState);
        };
      }
      // 2) Async reducer.
      else if (reduce is Future<St?> Function()) {
        return () async {
          //
          // The is the state returned by the reducer.
          final newState = await reduce();

          // This is the state right after the reducer returns,
          // but before it's committed to the store.
          final oldState = store.state;

          // If the reducer returned null, or returned the same instance,
          // don't do anything.
          if (newState == null || identical(store.state, newState)) {
            return newState;
          }

          return process(oldState: oldState, newState: newState);
        };
      }
      // Not defined.
      else {
        throw StoreException(
          'Reducer should return `St?` or `Future<St?>`. '
          'Do not return `FutureOr<St?>`. '
          "Reduce is of type: '${reduce.runtimeType}'.",
        );
      }
    }
  }
}
