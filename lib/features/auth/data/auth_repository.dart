import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user_model.dart';
import '../../../core/security/secure_session_store.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(apiClientProvider),
    ref.read(secureSessionStoreProvider),
  );
});

class AuthRepository {
  final Dio _dio;
  final SecureSessionStore _sessionStore;

  AuthRepository(this._dio, this._sessionStore);

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      await _sessionStore.saveToken(token);
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<void> logout() async {
    await _sessionStore.clearSession();
  }
}
