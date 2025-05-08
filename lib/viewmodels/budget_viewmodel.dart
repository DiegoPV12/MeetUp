import 'package:flutter/material.dart';
import '../services/budget_service.dart';

class BudgetViewModel extends ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> updateEventBudget(String eventId, double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _budgetService.updateBudget(eventId, amount);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
