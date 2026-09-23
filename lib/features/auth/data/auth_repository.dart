import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user_model.dart';
import '../../../core/security/secure_session_store.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(secureSessionStoreProvider));
});

class AuthRepository {
  final SecureSessionStore _sessionStore;

  AuthRepository(this._sessionStore);

  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (password != '1234') {
      throw Exception('Invalid password. Please use 1234.');
    }
    await _sessionStore.saveToken('fake_token_123');
    return UserModel(id: '1', email: '$username@example.com', name: username);
  }

  Future<void> logout() async {
    await _sessionStore.clearSession();
  }
}
