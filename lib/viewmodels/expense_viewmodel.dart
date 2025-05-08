import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses(String eventId) async {
    _isLoading = true;
    notifyListeners();
    _expenses = await _service.getExpenses(eventId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(String eventId, ExpenseModel newExpense) async {
    await _service.createExpense(eventId, newExpense);
    await loadExpenses(eventId);
  }

  Future<void> editExpense(String eventId, ExpenseModel updated) async {
    await _service.updateExpense(eventId, updated);
    await loadExpenses(eventId);
  }

  Future<void> deleteExpense(String eventId, String expenseId) async {
    await _service.deleteExpense(eventId, expenseId);
    _expenses.removeWhere((e) => e.id == expenseId);
    notifyListeners();
  }
}
