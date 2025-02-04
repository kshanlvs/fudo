import 'package:flutter/material.dart';
import '../../../../utils.dart/token_storage.dart';
import '../../../network/dio_client.dart';

class LoginService extends ChangeNotifier {
  Future<bool> login({required String identifier, required String password}) async {
    try {
      final response = await dioClient.post(
        "users/login",
        data: {
          "identifier": identifier,
          "password": password,
        },
      );

      if (response.statusCode != null && response.statusCode == 200) {
        // Store the token after successful login
        await _storeToken(response.data['access_token']);
        return true;
      } else {
        debugPrint("API Error: ${response.statusCode} - ${response.statusMessage}");
        return false;
      }
    } catch (e) {
      debugPrint("Dio error: $e");
      return false;
    }
  }

  Future _storeToken(String token) async {
    // Store the actual token received from the API
    await TokenStorage.instance.storeToken(token);
  }
}
