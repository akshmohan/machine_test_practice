import 'package:flutter/material.dart';
import 'package:machine_test_practice/views/home_page.dart';
import 'package:machine_test_practice/views/login_page.dart';

class Routes {
  Routes._();

  static const String homePage = '/home_page';
  static const String loginPage = '/login_page';

  static final dynamic route = <String, WidgetBuilder>{
    homePage: (context) => const HomePage(),
    loginPage: (context) => const LoginPage(),
  };
}