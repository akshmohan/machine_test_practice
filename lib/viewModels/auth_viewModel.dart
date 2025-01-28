// ignore_for_file: file_names, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/models/user_model.dart';
import 'package:machine_test_practice/repositories/auth_repository.dart';

class AuthViewmodel with ChangeNotifier{

  UserModel? _userModel;
  bool _isAuthenticated = false;

  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _isAuthenticated;


  Future<void> login (String username, String password) async {

    try{
      final _authRepository = AuthRepository();
      final result = await _authRepository.login(username, password);

     _isAuthenticated = true;

      _userModel = UserModel.fromJson(result);

      notifyListeners();
    } catch(e) {
      throw Exception(e.toString());
    }
  }

}


final authProvider = ChangeNotifierProvider<AuthViewmodel>((ref) => AuthViewmodel());