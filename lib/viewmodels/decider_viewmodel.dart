import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeciderViewModel extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<bool?> checkIfLoggedIn() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    final token = await storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      await storage.write(key: 'jwt_token', value: 'showcase-token');
    }

    _isLoading = false;
    notifyListeners();

    return true;
  }
}
