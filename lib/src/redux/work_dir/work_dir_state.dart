import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/path.dart';

part 'work_dir_state.freezed.dart';

@freezed
abstract class WorkDirState with _$WorkDirState {
  const factory WorkDirState({
    DirectoryPath? path,
    @Default(false) bool willCreateIfNotExists,
  }) = _WorkDirState;
}
