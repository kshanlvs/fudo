import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Private constructor for singleton pattern
  TokenStorage._privateConstructor();

  // Static instance of the singleton
  static final TokenStorage instance = TokenStorage._privateConstructor();

  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key for storing the access token
  static const String _tokenKey = 'access_token';

  // Store token securely
  Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve the token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete the token (useful for logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Check if the token exists (useful for checking if the user is logged in)
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }
}
