import 'package:cli_utils/cli_utils.dart';

import '../failure/common.dart';
import '../failure/failure.dart';

/// Extension providing validation methods for [DirectoryPath].
///
/// This extension adds various validation methods to check the state
/// of a directory path and return appropriate failures when validation fails.
extension DirectoryPathValidation on DirectoryPath {
  /// Validates that the directory exists.
  ///
  /// Returns a [DirectoryNotFoundFailure] if the directory does not exist,
  /// otherwise returns `null` indicating the validation passed.
  ///
  /// Example:
  /// ```dart
  /// final dir = DirectoryPath('/path/to/dir');
  /// if (dir.validateExists() case final failure?) {
  ///   print('Directory not found: ${failure.message}');
  /// }
  /// ```
  Failure? validateExists() {
    if (notFound) {
      return DirectoryNotFoundFailure(path);
    }

    return null;
  }

  /// Validates that the path points to a directory (not a file).
  ///
  /// Returns a [NotADirectoryFailure] if the path exists but is not a
  /// directory,
  /// otherwise returns `null` indicating the validation passed.
  ///
  /// Note: This method only validates if the path exists. If the path doesn't
  /// exist, it returns `null` (no failure).
  ///
  /// Example:
  /// ```dart
  /// final dir = DirectoryPath('/path/to/file.txt');
  /// if (dir.validateIsDirectory() case final failure?) {
  ///   print('Not a directory: ${failure.message}');
  /// }
  /// ```
  Failure? validateIsDirectory() {
    if (!notFound && !isDirectory) {
      return NotADirectoryFailure(path);
    }

    return null;
  }

  /// Performs complete validation of the directory path.
  ///
  /// This method combines [validateExists] and [validateIsDirectory]
  /// validations. It checks:
  /// 1. The directory exists
  /// 2. The path points to a directory (not a file)
  ///
  /// Returns the first [Failure] encountered, or `null` if all validations
  /// pass.
  ///
  /// Example:
  /// ```dart
  /// final dir = DirectoryPath('/path/to/dir');
  /// if (dir.validate() case final failure?) {
  ///   logger.err(failure.message);
  ///   return failure.exitCode;
  /// }
  /// // Directory is valid, proceed with operations
  /// ```
  Failure? validate() => validateExists() ?? validateIsDirectory();
}
