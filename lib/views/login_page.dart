// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/config/routes.dart';
import 'package:machine_test_practice/core/custom_dialog.dart';
import 'package:machine_test_practice/core/custom_text_field.dart';
import 'package:machine_test_practice/core/loader.dart';
import 'package:machine_test_practice/core/snackbar.dart';
import 'package:machine_test_practice/viewModels/auth_viewModel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final key = GlobalKey<FormState>();

  late final authViewModel = ref.watch(authProvider);

  final isObscureProvider = StateProvider<bool>((ref) => true);

  final isLoadingProvider = StateProvider<bool>((ref) => false);

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isObscure = ref.watch(isObscureProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginpage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      controller: usernameController,
                      label: "Username",
                      hintText: "Enter Username",
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter password',
                      obscureText: isObscure,
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: Icon(isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          ref.read(isObscureProvider.notifier).state =
                              !isObscure;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (key.currentState!.validate()) {
                                  ref.read(isLoadingProvider.notifier).state =
                                      true;

                                  try {
                                    await authViewModel.login(
                                      usernameController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                    if (authViewModel.isAuthenticated) {
                                      showSnackBar(
                                          context, "Logged in successfully!");

                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Routes.homePage, (route) => false);
                                    }
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          title: "Invalid Credentials!",
                                          content:
                                              "The username or password you entered is incorrect. Please try again.",
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } finally {
                                    ref.read(isLoadingProvider.notifier).state =
                                        false;
                                  }
                                }
                              },
                        child: const Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
                color: Colors.black.withAlpha(128), child: const Loader()),
        ],
      ),
    );
  }
}
