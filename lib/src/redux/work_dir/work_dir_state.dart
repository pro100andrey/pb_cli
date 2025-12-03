import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/path.dart';
import '../models/enums/resolve_work_dir.dart';

part 'work_dir_state.freezed.dart';

@freezed
abstract class WorkDirState with _$WorkDirState {
  const factory WorkDirState({
    DirectoryPath? path,
    ResolveWorkDirOption? resolveOption,
  }) = _WorkDirState;
}
