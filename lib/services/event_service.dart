import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meetup/models/event_request_model.dart';
import '../models/event_model.dart';
import '../utils/constants.dart';

class EventService {
  final _storage = const FlutterSecureStorage();

  Future<void> createEvent(EventRequest eventRequest) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No hay token');

    final response = await http.post(
      Uri.parse(Constants.events),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
      body: jsonEncode(eventRequest.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear evento: ${response.body}');
    }
  }

  Future<List<EventModel>> fetchEvents() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No hay token');

    final response = await http.get(
      Uri.parse(Constants.events),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener eventos');
    }
  }

  Future<EventModel> fetchEventById(String eventId) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No hay token');

    final response = await http.get(
      Uri.parse('${Constants.events}/$eventId'),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return EventModel.fromJson(data);
    } else {
      throw Exception('Error al cargar evento');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No hay token');

    final response = await http.delete(
      Uri.parse('${Constants.events}/$eventId'),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar evento');
    }
  }

  Future<void> cancelEvent(String eventId) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('No hay token');

    final response = await http.patch(
      Uri.parse('${Constants.events}/$eventId/cancel'),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cancelar evento');
    }
  }
}
