import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meetup/models/collaborator_model.dart';
import 'package:meetup/utils/constants.dart';

class CollaboratorService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<List<CollaboratorModel>> getAllUsers() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse(Constants.users),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error al obtener la lista de usuarios');
    }

    final data = jsonDecode(res.body)['data'] as List<dynamic>;
    return data.map((e) => CollaboratorModel.fromJson(e)).toList();
  }

  Future<List<CollaboratorModel>> getEventCollaborators(String eventId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${Constants.events}/$eventId/collaborators'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Error al obtener colaboradores del evento');
    }

    final data = jsonDecode(res.body)['data'] as List<dynamic>;
    return data.map((e) => CollaboratorModel.fromJson(e)).toList();
  }

  Future<void> addCollaborator(String eventId, String userId) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse('${Constants.events}/$eventId/collaborators/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'collaboratorId': userId}),
    );
    if (res.statusCode != 200) {
      throw Exception('Error al agregar colaborador');
    }
  }

  Future<void> removeCollaborator(String eventId, String userId) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse('${Constants.events}/$eventId/collaborators/remove'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'collaboratorId': userId}),
    );
    if (res.statusCode != 200) {
      throw Exception('Error al eliminar colaborador');
    }
  }
}
