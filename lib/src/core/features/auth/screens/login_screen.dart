import 'package:flutter/material.dart';
import 'package:fudo/src/colors_constants.dart';
import 'package:fudo/src/core/features/auth/service/login_service.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifier = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final iconTheme = Theme.of(context).iconTheme;
    final loginProvider = context.read<LoginService>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/chicken.png', // Path to your image
                    height: 100, // Adjust the size as needed
                    width: 100, // Adjust the size as needed
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    "Fudo",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Fresh, Hot, and Delivered",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 146, 10, 55),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _identifier,
                    decoration: InputDecoration(
                      labelText: 'Mobile/Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.person, color: iconTheme.color),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number or email';
                      }

                      // Regex for email validation
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      // Regex for mobile number validation (10 digits, adjust as needed)
                      final mobileRegex = RegExp(r'^\d{10}$');

                      if (!emailRegex.hasMatch(value) &&
                          !mobileRegex.hasMatch(value)) {
                        return 'Please enter a valid email or 10-digit mobile number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.lock, color: iconTheme.color),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await loginProvider.login(
                          identifier: _identifier.text,
                          password: _passwordController.text,
                        )) {
                          if (context.mounted) {
                            context.go(RouteLocation.homeScreen);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Don't have an account ??"),
                    const WidgetSpan(
                        child: SizedBox(
                      width: 5,
                    )),
                    WidgetSpan(
                        child: InkWell(
                      onTap: () {
                        try {
                              context.go(RouteLocation.register);
                        } catch (e) {
                          throw Exception(e.toString());
                        }
                                              

                      },
                      child: const Text('Register',
                          style: TextStyle(color: AppColors.primaryTextColor)),
                    ))
                  ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
