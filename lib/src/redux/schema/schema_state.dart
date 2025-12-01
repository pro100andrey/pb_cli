import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'schema_state.freezed.dart';

@freezed
abstract class SchemaState with _$SchemaState {
  const factory SchemaState({
    List<CollectionModel>? collections,
    List<String>? managedCollections,
  }) = _SchemaState;
}
