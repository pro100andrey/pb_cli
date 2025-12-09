import 'package:cli_utils/cli_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/enums/command.dart';

part 'work_dir_state.freezed.dart';

@freezed
sealed class WorkDirState with _$WorkDirState {
  const factory WorkDirState.unresolved() = UnresolvedWorkDir;

  const factory WorkDirState.resolved({
    required DirectoryPath path,
    required CommandContext context,
  }) = ResolvedWorkDir;
}
