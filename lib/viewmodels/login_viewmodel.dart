import 'package:flutter/material.dart';
import '../models/login_request_model.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      await storage.write(key: 'jwt_token', value: response.token);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
