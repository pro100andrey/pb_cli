import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'records_state.freezed.dart';

@freezed
abstract class RecordsState with _$RecordsState {
  const factory RecordsState({
    @Default(IMapConst({})) IMap<String, IList<RecordModel>> byCollectionName,
  }) = _RecordsState;
}
