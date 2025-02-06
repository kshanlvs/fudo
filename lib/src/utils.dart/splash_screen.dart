import 'package:flutter/material.dart';

import 'package:fudo/src/utils.dart/token_storage.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wait for a while and check if user is logged in
    Future.delayed(const Duration(seconds: 2), () async {
      final isLoggedIn = await TokenStorage.instance.isLoggedIn();
      // Navigate based on login status
      if   (context.mounted &&   isLoggedIn) {
        // Navigate to Home Screen if logged in
        context.go('/home-page');
      } else {
         if(context.mounted){
          context.go('/login');
         }
        
      }
    });

    return  Scaffold(
      body: Center(
        child:Image.asset(
           height: 50,
           width: 50,
          "assets/images/loading_gif.gif"), // Splash screen indicator
      ),
    );
  }
}
