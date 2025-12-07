import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_schema_state.freezed.dart';

@freezed
abstract class LocalSchemaState with _$LocalSchemaState {
  const factory LocalSchemaState() = _LocalSchemaState;
}
