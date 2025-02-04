import 'package:fudo/src/core/features/auth/screens/user_registration.dart';
import 'package:fudo/src/core/features/auth/screens/verify_otp_screen.dart';
import 'package:fudo/src/core/features/dashboard/screens/home_screen.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:go_router/go_router.dart';

import '../../utils.dart/token_storage.dart';
import '../features/auth/screens/login_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if the user is logged in
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
        builder: (context, state) => const HomeScreen(),
      ),
    
    ],
  );
}
