import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/expense_model.dart';
import '../utils/constants.dart';

class ExpenseService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<List<ExpenseModel>> getExpenses(String eventId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${Constants.events}/$eventId/expenses'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final data = decoded['data'] as List<dynamic>;
      return data.map((e) => ExpenseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener gastos');
    }
  }

  Future<void> createExpense(String eventId, ExpenseModel expense) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('${Constants.events}/$eventId/expenses'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(expense.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al registrar gasto');
    }
  }

  Future<void> updateExpense(String eventId, ExpenseModel expense) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse('${Constants.events}/$eventId/expenses/${expense.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(expense.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Error al actualizar gasto');
  }

  Future<void> deleteExpense(String eventId, String expenseId) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('${Constants.events}/$eventId/expenses/$expenseId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) throw Exception('Error al eliminar gasto');
  }
}
