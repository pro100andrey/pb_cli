import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'remote_schema_state.freezed.dart';

@freezed
abstract class RemoteSchemaState with _$RemoteSchemaState {
  const factory RemoteSchemaState({List<CollectionModel>? collections}) =
      _RemoteSchemaState;
}
