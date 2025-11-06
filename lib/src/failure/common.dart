import '../extensions/string_style.dart';
import 'failure.dart';

class DirectoryNotFoundFailure extends Failure {
  DirectoryNotFoundFailure(String path)
    : super.io(
        message:
            'Directory not found: ${path.bold.underlined}. '
            'Please ensure the path is correct or use the '
            '${'setup'.bold.underlined} command to initialize the directory.',
      );
}

class NotADirectoryFailure extends Failure {
  NotADirectoryFailure(String path)
    : super.io(
        message:
            'The path ${path.bold.underlined} is not a directory. '
            'Please provide a valid directory path.',
      );
}

extension FailureWrappersExt on Failure {
  String get fetchCollectionsSchema =>
      'Failed to fetch collections schema: $message';
}
