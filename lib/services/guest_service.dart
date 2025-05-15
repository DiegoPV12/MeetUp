import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/guest_model.dart';
import '../utils/constants.dart';

class GuestService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<List<GuestModel>> getGuestsByEvent(String eventId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('${Constants.guests}/event/$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    debugPrint(res.body);
    final data = jsonDecode(res.body)['data'] as List;
    return data.map((g) => GuestModel.fromJson(g)).toList();
  }

  Future<void> createGuest(GuestModel guest) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse(Constants.guests),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(guest.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear invitado');
    }
  }

  Future<void> updateGuest(GuestModel guest) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse('${Constants.guests}/${guest.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': guest.name,
        'email': guest.email,
        'status': guest.status,
      }),
    );
    print(res.body);
    if (res.statusCode != 200) {
      throw Exception('Error al actualizar invitado');
    }
  }

  Future<void> deleteGuest(String id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('${Constants.guests}/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Error al eliminar invitado');
    }
  }
}
