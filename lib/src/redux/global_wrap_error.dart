import 'store.dart';

// ignore: one_member_abstracts
abstract class GlobalWrapError<St> {
  Object? wrap(
    Object error,
    StackTrace stackTrace,
    ReduxAction<St> action,
  );
}
