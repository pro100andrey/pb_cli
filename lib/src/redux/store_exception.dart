class StoreException implements Exception {
  const StoreException(this.msg);

  final String msg;

  @override
  String toString() => msg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreException &&
          runtimeType == other.runtimeType &&
          msg == other.msg;

  @override
  int get hashCode => msg.hashCode;
}
