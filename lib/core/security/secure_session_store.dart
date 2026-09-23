import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureSessionStoreProvider = Provider<SecureSessionStore>((ref) {
  return SecureSessionStore();
});

class SecureSessionStore {
  String? _mockToken;

  Future<void> saveToken(String token) async {
    _mockToken = token;
  }

  Future<String?> getToken() async {
    return _mockToken;
  }

  Future<void> clearSession() async {
    _mockToken = null;
  }
}
