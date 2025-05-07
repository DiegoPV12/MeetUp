// lib/viewmodels/task_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _svc = TaskService();

  /* ─────────────────────  estado ───────────────────── */
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  /* ───────────────── cargar listado ───────────────── */
  Future<void> loadTasks(String eventId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _svc.getTasksByEvent(eventId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /* ───────────────── alta / edición ───────────────── */
  Future<void> addTask(String eventId, String title, String desc) async {
    await _svc.createTask(eventId, title, desc);
    await loadTasks(eventId);
  }

  Future<void> editTask(
    String id,
    String title,
    String desc,
    String eventId,
  ) async {
    await _svc.editTask(id, title, desc);
    await loadTasks(eventId);
  }

  /* ─────────────── eliminación (con undo local) ─────────────── */
  TaskModel? _lastDeleted;
  int? _lastIndex;

  Future<void> deleteTask(String id, String eventId) async {
    _lastIndex = _tasks.indexWhere((t) => t.id == id);
    if (_lastIndex! < 0) return;
    _lastDeleted = _tasks.removeAt(_lastIndex!);
    notifyListeners(); // ⚡️ la UI la quita al instante

    try {
      await _svc.deleteTask(id); // backend
    } catch (_) {
      // revertimos si falla
      _tasks.insert(_lastIndex!, _lastDeleted!);
      notifyListeners();
      rethrow;
    }
  }

  ///  Restaurar tras “deshacer”
  void restoreLastDeleted() {
    if (_lastDeleted == null) return;
    _tasks.insert(_lastIndex!, _lastDeleted!);
    _lastDeleted = null;
    notifyListeners();
  }

  /* ────────────────  OPTIMISTIC UPDATE para drag ──────────────── */
  /// Mueve la tarea localmente – sin esperar al servidor
  void moveTaskOptimistic(TaskModel task, String newStatus) {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i == -1) return;
    _tasks[i] = task.copyWith(status: newStatus);
    notifyListeners();
  }

  /// Revierte la tarea al estado anterior (se usa cuando el usuario cancela
  /// en la papelera)
  void revertTaskStatus(TaskModel task, String previousStatus) {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i == -1) return;
    _tasks[i] = task.copyWith(status: previousStatus);
    notifyListeners();
  }

  /// Persiste el cambio en el backend; revierte si falla.
  Future<void> persistStatus(TaskModel task, String newStatus) async {
    final oldStatus = task.status;
    try {
      await _svc.updateTaskStatus(task.id, newStatus);
    } catch (_) {
      revertTaskStatus(task, oldStatus);
      rethrow;
    }
  }

  /*  ✨ alias opcional – por si en alguna parte antigua se sigue llamando
      a setTaskStatus(id, status). Mantiene compatibilidad.               */
  Future<void> setTaskStatus(String id, String newStatus) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    moveTaskOptimistic(task, newStatus);
    await persistStatus(task, newStatus);
  }
}
