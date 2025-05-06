import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks(String eventId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _taskService.getTasksByEvent(eventId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String eventId, String title, String description) async {
    await _taskService.createTask(eventId, title, description);
    await loadTasks(eventId);
  }

  Future<void> toggleTaskStatus(String taskId, String currentStatus) async {
    final next =
        currentStatus == 'pending'
            ? 'in_progress'
            : currentStatus == 'in_progress'
            ? 'completed'
            : 'pending';
    await _taskService.updateTaskStatus(taskId, next);
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.status = next;
    notifyListeners();
  }

  Future<void> setTaskStatus(String taskId, String newStatus) async {
    await _taskService.updateTaskStatus(taskId, newStatus);
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.status = newStatus;
    notifyListeners();
  }

  Future<void> editTask(
    String taskId,
    String title,
    String description,
    String eventId,
  ) async {
    await _taskService.editTask(taskId, title, description);
    await loadTasks(eventId);
  }

  Future<void> deleteTask(String taskId, String eventId) async {
    await _taskService.deleteTask(taskId);
    await loadTasks(eventId);
  }

  Future<void> insertTaskAt(TaskModel task, int index) async {
    _tasks.insert(index, task);
    notifyListeners();
  }
}
