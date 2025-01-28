import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/viewModels/auth_viewModel.dart';
import 'package:machine_test_practice/views/home_page.dart';
import 'package:machine_test_practice/views/login_page.dart';

void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  final authViewModel = ref.watch(authProvider);

  if(!authViewModel.isInitialised) {
    return const MaterialApp(
      home:  Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
      )),
    );
  }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authViewModel.isAuthenticated ? const HomePage() : const LoginPage(),
    );
  }
}
