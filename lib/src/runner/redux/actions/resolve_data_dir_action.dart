import 'package:path/path.dart' as p;

import '../../../utils/path.dart';
import '../../../utils/validation.dart';
import 'action.dart';

final class ResolveDataDirAction extends AppAction {
  ResolveDataDirAction({required this.dir});

  final String dir;

  @override
  AppState reduce() {
    final dirPath = DirectoryPath(dir);

    final failure = dirPath.validateIsDirectory();
    if (failure != null) {
      throw Exception(failure.message);
    }

    return state.copyWith(dataDir: dirPath);
  }

  @override
  String toString() => 'ResolveDataDirAction(dir: ${p.canonicalize(dir)})';
}
