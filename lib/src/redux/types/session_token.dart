import 'dart:convert';

extension type const SessionToken(String value) implements String {
  Map<String, dynamic> get payload {
    try {
      final parts = value.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid JWT token format');
      }

      final tokenPart = base64.normalize(parts[1]);
      final rawDataPart = base64Decode(tokenPart);
      final dataPart = utf8.decode(rawDataPart);
      final payload = jsonDecode(dataPart) as Map<String, dynamic>;

      return payload;
    } on Exception catch (e) {
      throw FormatException('Failed to decode JWT token payload: $e');
    }
  }

  bool get isValid {
    try {
      final expiryDate = this.expiryDate;
      return expiryDate.isAfter(DateTime.now());
    } on Exception {
      return false;
    }
  }

  DateTime get expiryDate {
    final payload = this.payload;
    final exp = payload['exp'] is int
        ? payload['exp'] as int
        : (int.tryParse(payload['exp'].toString()) ?? 0);

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
}
