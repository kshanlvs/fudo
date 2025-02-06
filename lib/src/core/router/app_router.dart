import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/auth/screens/login_screen.dart';
import 'package:fudo/src/core/features/auth/screens/user_registration.dart';
import 'package:fudo/src/core/features/auth/screens/verify_otp_screen.dart';
import 'package:fudo/src/core/features/dashboard/screens/home_screen.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:fudo/src/utils.dart/splash_screen.dart';
import 'package:fudo/src/utils.dart/token_storage.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
  
    
    initialLocation: '/',
  
    redirect: (context, state) async {
      final isLoggedIn = await TokenStorage.instance.isLoggedIn();
      if (state.fullPath == RouteLocation.register || state.fullPath == RouteLocation.loginScreen) {
        return null; // Don't apply any redirection for registration and login
      }

      if (isLoggedIn) {
        // Allow access to all other pages
        return null;
      } else {
        // Redirect to login page if not logged in
        return '/login';
      }
    },
    
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),  // Set Splash Screen as the initial route
      ),
      GoRoute(
        path: '/registration-page',
        builder: (context, state) => const RegistrationForm(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) => const VerifyOtpScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home-page',
          pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
      ),
    ],
    
  );
  
}
