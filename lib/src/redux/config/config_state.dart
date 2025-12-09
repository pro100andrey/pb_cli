import 'package:freezed_annotation/freezed_annotation.dart';

import '../types/config.dart';
import 'actions/load_config_action.dart';
import 'actions/save_config_action.dart';

part 'config_state.freezed.dart';

/// State representing configuration loaded from config.json file.
///
/// This is the source of truth for what exists in the config.json file
/// on disk. The state stores configuration as [ConfigData], which provides
/// type-safe access to CLI settings.
///
/// The data is populated by [LoadConfigAction] and updated by
/// [SaveConfigAction].
@freezed
abstract class ConfigState with _$ConfigState {
  const factory ConfigState({
    /// Configuration data loaded from config.json file.
    ///
    /// Empty if the file doesn't exist or hasn't been loaded yet.
    @Default(ConfigData.empty()) ConfigData data,
  }) = _ConfigState;

  const ConfigState._();
}
