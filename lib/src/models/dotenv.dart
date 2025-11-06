/// Keys used in .env files for PocketBase credentials.
extension type const DotenvKey._(String value) implements String {
  /// Creates a [DotenvKey] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not a known key.
  factory DotenvKey(String value) {
    if (!_known.contains(value)) {
      throw ArgumentError('Unknown DotenvKey: $value');
    }

    return DotenvKey._(value);
  }

  /// Host key for PocketBase instance.
  static const pbHost = DotenvKey._('PB_HOST');

  /// Username or email key for PocketBase authentication.
  static const pbUsername = DotenvKey._('PB_USERNAME');

  /// Password key for PocketBase authentication.
  static const pbPassword = DotenvKey._('PB_PASSWORD');

  /// Token key for PocketBase authentication.
  static const pbToken = DotenvKey._('PB_TOKEN');

  /// Set of all known [DotenvKey]s.
  static const Set<DotenvKey> _known = {
    pbHost,
    pbUsername,
    pbPassword,
    pbToken,
  };
}

/// Env data structure representing .env key-value pairs.
extension type const Dotenv(Map<DotenvKey, String> data) {
  /// Returns the value for the [DotenvKey.pbHost] key.
  String? get pbHost => data[DotenvKey.pbHost];

  /// Returns the value for the [DotenvKey.pbUsername] key.
  String? get pbUsername => data[DotenvKey.pbUsername];

  /// Returns the value for the [DotenvKey.pbPassword] key.
  String? get pbPassword => data[DotenvKey.pbPassword];

  /// Returns the value for the [DotenvKey.pbToken] key.
  String? get pbToken => data[DotenvKey.pbToken];

  bool get isComplete =>
      pbHost != null &&
      pbUsername != null &&
      pbPassword != null &&
      pbToken != null;

  Dotenv copyWith({
    String? pbHost,
    String? pbUsername,
    String? pbPassword,
    String? pbToken,
  }) => Dotenv({
    DotenvKey.pbHost: pbHost ?? this.pbHost!,
    DotenvKey.pbUsername: pbUsername ?? this.pbUsername!,
    DotenvKey.pbPassword: pbPassword ?? this.pbPassword!,
    DotenvKey.pbToken: pbToken ?? this.pbToken!,
  });
}
