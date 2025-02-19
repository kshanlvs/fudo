import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/auth/models/profile.dart';
import 'package:fudo/src/core/network/dio_client.dart';

class ProfileService extends ChangeNotifier {
  Profile? profile = Profile();
  bool isLoading = false;

  

  Future getProfile() async {

     
    try {
      
      isLoading = true;
      final response = await dioClient.get('profile/');
      if (response.statusCode == HttpStatus.ok) {
        profile = Profile.fromJson(response.data);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
    }
  }
}
