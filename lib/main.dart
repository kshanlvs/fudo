import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/auth/service/login_service.dart';
import 'package:fudo/src/core/features/auth/service/registeration_service.dart';
import 'package:fudo/src/core/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp();
    await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    FirebaseAuth.instance.setLanguageCode('en');
  await ndotenv.load();
  runApp(MultiProvider(
    providers: providers,
    child: const MyApp()));
}

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (_) => RegisterationService()),
    ChangeNotifierProvider(create: (_) => LoginService()),


  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the color scheme for the app
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.grey, width: .5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.grey, width: 1),
          ),
          labelStyle:
              const TextStyle(color: Colors.black),
          prefixIconColor: Colors.grey,
          suffixIconColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                const Color(0xFFf66428),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 24,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
