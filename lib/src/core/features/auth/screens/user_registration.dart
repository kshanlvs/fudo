import 'package:flutter/material.dart';
import 'package:fudo/src/colors_constants.dart';
import 'package:fudo/src/core/features/auth/service/registeration_service.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final iconTheme = Theme.of(context).iconTheme;
    final registrationProvider = context.read<RegisterationService>();
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
                  const Text(
                    "Welcome To Fudo",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: roundedInputBorders(),
                      prefixIcon: Icon(Icons.person, color: iconTheme.color),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: roundedInputBorders(),
                      prefixIcon: Icon(Icons.email, color: iconTheme.color),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mobile Field with Rounded Border
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      border: roundedInputBorders(),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: iconTheme.color,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field with Rounded Border
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: roundedInputBorders(),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: iconTheme.color,
                      ),
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
                  const SizedBox(height: 16),

                  // Confirm Password Field with Rounded Border
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: roundedInputBorders(),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: iconTheme.color,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .80,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final userCreated =
                              await registrationProvider.initialRegistration({
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "phone": _mobileController.text,
                            "password": _passwordController.text
                          });

                          if (context.mounted && userCreated) {
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registration successful!')),
                            );

                            // Navigate to the login screen after a short delay
                            Future.delayed(const Duration(seconds: 2), () {
                              if (context.mounted) {
                                context.go(RouteLocation.loginScreen);
                              }
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                   Text.rich(TextSpan(children: [
                    const TextSpan(text: "Already have an account ??"),
                    const WidgetSpan(
                        child: SizedBox(
                      width: 5,
                    )),
                    WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            context.go(RouteLocation.loginScreen);
                          },
                      child: const Text('Login',
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

  OutlineInputBorder roundedInputBorders() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 1),
    );
  }
}
