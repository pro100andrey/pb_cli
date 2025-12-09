import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'remote_schema_state.freezed.dart';

/// State of the remote PocketBase schema.
///
/// Contains information about collections fetched from the remote server.
@freezed
abstract class RemoteSchemaState with _$RemoteSchemaState {
  const factory RemoteSchemaState({
    /// Map of collections by their ID for fast O(1) access.
    @Default(IMapConst({})) IMap<String, CollectionModel> byId,

    /// List of all collection IDs in the order received from the server.
    @Default(IListConst([])) IList<String> sorted,

    /// List of IDs for user collections only (excluding system collections).
    @Default(IListConst([])) IList<String> sortedWithoutSystem,
  }) = _RemoteSchemaState;
}
