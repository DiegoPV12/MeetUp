import '../models/expense_model.dart';
import 'showcase_data.dart';

class ExpenseService {
  Future<List<ExpenseModel>> getExpenses(String eventId) async {
    return ShowcaseData.expenses
        .where((expense) => expense.eventId == eventId)
        .toList();
  }

  Future<void> createExpense(String eventId, ExpenseModel expense) async {
    ShowcaseData.expenses.add(
      ExpenseModel(
        id: ShowcaseData.nextExpenseId(),
        name: expense.name,
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        date: expense.date,
        eventId: eventId,
      ),
    );
  }

  Future<void> updateExpense(String eventId, ExpenseModel expense) async {
    final index = ShowcaseData.expenses
        .indexWhere((existing) => existing.id == expense.id);
    if (index == -1) return;
    ShowcaseData.expenses[index] = expense;
  }

  Future<void> deleteExpense(String eventId, String expenseId) async {
    ShowcaseData.expenses.removeWhere((expense) => expense.id == expenseId);
  }
}
