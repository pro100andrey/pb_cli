import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'remote_schema_state.freezed.dart';

@freezed
abstract class RemoteSchemaState with _$RemoteSchemaState {
  const factory RemoteSchemaState({
    @Default(IMapConst({})) IMap<String, CollectionModel> byId,
    @Default(IListConst([])) IList<String> sorted,
  }) = _RemoteSchemaState;
}
