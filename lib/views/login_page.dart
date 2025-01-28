// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/viewModels/auth_viewModel.dart';
import 'package:machine_test_practice/views/home_page.dart';

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

  @override
  void dispose() {
    super.dispose();
    
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      label: const Text("Username", style: TextStyle(color: Colors.white),),
                      hintText: "Enter username",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    label: const Text("Password", style: TextStyle(color: Colors.white),),
                    hintText: "Enter password",
                     hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Login"),
                    onPressed: () async{
                      if (key.currentState!.validate()) {
                      await authViewModel.login(usernameController.text.trim(), passwordController.text.trim());

                      if(authViewModel.isAuthenticated) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
