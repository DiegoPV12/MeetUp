import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class BudgetService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<void> updateBudget(String eventId, double totalBudget) async {
    final token = await _getToken();
    final body = jsonEncode({'budget': totalBudget});
    debugPrint(token);

    final response = await http.put(
      Uri.parse('${Constants.events}/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    debugPrint(response.body);
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar presupuesto');
    }
  }
}
