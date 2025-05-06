import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<List<TaskModel>> getTasksByEvent(String eventId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${Constants.tasks}/event/$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final data = decoded['data'] as List;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener tareas');
    }
  }

  Future<void> createTask(
    String eventId,
    String title,
    String description,
  ) async {
    final token = await _getToken();
    final body = jsonEncode({
      'event': eventId,
      'title': title,
      'description': description,
    });
    final res = await http.post(
      Uri.parse(Constants.tasks),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    debugPrint(body);
    debugPrint(res.body);
    final decoded = jsonDecode(res.body);
    if (res.statusCode != 200 && res.statusCode != 201 ||
        decoded['success'] != true) {
      debugPrint('Error body: ${res.body}');
      throw Exception('Error al crear tarea');
    }
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    final token = await _getToken();
    final body = jsonEncode({'status': status});
    final res = await http.patch(
      Uri.parse('${Constants.tasks}/$taskId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    debugPrint(token);
    debugPrint('Request body: $body');
    debugPrint('Response status: ${res.statusCode}');
    debugPrint('Response body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Error al actualizar estado');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('${Constants.tasks}/$taskId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Error al eliminar tarea');
    }
  }

  Future<void> editTask(String taskId, String title, String description) async {
    final token = await _getToken();
    final body = jsonEncode({'title': title, 'description': description});

    final res = await http.put(
      Uri.parse('${Constants.tasks}/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode != 200) {
      debugPrint('Error body: ${res.body}');
      throw Exception('Error al editar tarea');
    }
  }
}
