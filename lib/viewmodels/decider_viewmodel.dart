import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

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
      _isLoading = false;
      notifyListeners();
      return false;
    }

    debugPrint(token);
    final isValid = await _validateToken(token);

    _isLoading = false;
    notifyListeners();

    return isValid;
  }

  Future<bool?> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Constants.meUrl),
        headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        await storage.delete(key: 'jwt_token');
        return false;
      }
    } catch (_) {
      _hasError = true;
      notifyListeners();
      return null;
    }
  }
}
