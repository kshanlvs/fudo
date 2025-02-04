import 'package:flutter/material.dart';
import 'package:fudo/src/core/firebase_auth_service.dart';
import 'package:fudo/src/core/network/dio_client.dart';

class RegisterationService extends ChangeNotifier {
  AuthService firebaseAuth = AuthService();
  // api to create user
  Future<bool> initialRegistration(Map<String, dynamic> payLoad) async {
    try {
      final response = await dioClient.post("users/", data: payLoad);
      if (response.statusCode != null && response.statusCode! ~/ 100 == 2) {
        return true;
      }
      debugPrint(
          "API Error: ${response.statusCode} - ${response.statusMessage}");
      return false;
    } catch (e) {
      debugPrint("Dio error: $e");
      return false;
    }
  }
}
