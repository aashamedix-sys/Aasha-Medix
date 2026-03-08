import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserRole = 'user_role';

  static Future<void> saveAuthData({
    required String token,
    required String userId,
    required String role,
  }) async {
    try {
      await Future.wait([
        _storage.write(key: _keyToken, value: token),
        _storage.write(key: _keyUserId, value: userId),
        _storage.write(key: _keyUserRole, value: role),
      ]);
    } catch (e) {
      log('SecureStorage write error: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (e) {
      log('SecureStorage read error: $e');
      return null;
    }
  }

  static Future<String?> getUserRole() async {
    try {
      return await _storage.read(key: _keyUserRole);
    } catch (e) {
      log('SecureStorage read role error: $e');
      return null;
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      log('SecureStorage clear error: $e');
    }
  }
}
