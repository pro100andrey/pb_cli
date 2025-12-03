enum ResolveWorkDirOption {
  /// Resolve work directory, creating it if it does not exist.
  createIfNotExists,

  /// Resolve work directory, prompting the user if it does not exist.
  useDifferentPath
  ;

  /// Human-readable title of the option
  String get title {
    switch (this) {
      case createIfNotExists:
        return 'Create If Not Exists';
      case useDifferentPath:
        return 'Use Different Path';
    }
  }
}
