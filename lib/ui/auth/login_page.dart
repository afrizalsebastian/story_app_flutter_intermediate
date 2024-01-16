import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/user.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;
  const LoginPage({super.key, required this.onRegister, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Welcome back, glad to see you again!',
                    style: TextStyle(
                      color: Styles.textColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Styles.primaryColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      focusColor: Styles.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Styles.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Styles.primaryColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      focusColor: Styles.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Styles.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  context.watch<AuthProvider>().isLoadingLogin
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final User user = User(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              final authRead = context.read<AuthProvider>();

                              final result = await authRead.login(user);
                              if (result) {
                                widget.onLogin();
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authRead.errorLogin,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Styles.primaryColor),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Styles.textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onRegister(),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Styles.primaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
