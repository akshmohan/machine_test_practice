// ignore_for_file: file_names, prefer_final_fields, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/models/user_model.dart';
import 'package:machine_test_practice/repositories/auth_repository.dart';
import 'package:machine_test_practice/services/storage_service.dart';

class AuthViewmodel with ChangeNotifier {
  String? _accessToken;
  String? _username;
  UserModel? _userModel;
  bool _isAuthenticated = false;
  bool _isInitialised = false;
  bool _isLoading = false;

  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialised => _isInitialised;
  String? get accessToken => _accessToken;
  String? get username => _username;
  bool get isLoading => _isLoading;

  AuthViewmodel() {
    _persistUser();
  }

  Future<void> _persistUser() async {
    try {
      final _storageService = StorageService();
      final accessToken = await _storageService.getAccessToken();
      final username = await _storageService.getUsername();
      if (accessToken != null) {
        _isAuthenticated = true;
        _userModel = UserModel(accessToken: accessToken);
        _accessToken = accessToken;
        if (username != null) {
          _username = username;
        }
      }
    } catch (_) {
      _isAuthenticated = false;
      _userModel = null;
    }
    _isInitialised = true;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final _authRepository = AuthRepository();
      final result = await _authRepository.login(username, password);
      if (result['accessToken'] != null) {
        final _storageService = StorageService();
        await _storageService.saveAccessToken(result['accessToken']);
        await _storageService.saveUsername(username);
        _accessToken = result['accessToken'];
        _username = username;
      } else {
        throw Exception("Access token not found");
      }

      _isAuthenticated = true;

      _userModel = UserModel.fromJson(result);

      _isLoading = false;

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      final _authRepository = AuthRepository();
      await _authRepository.logout();

      _isAuthenticated = false;
      _userModel = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final authProvider =
    ChangeNotifierProvider<AuthViewmodel>((ref) => AuthViewmodel());
