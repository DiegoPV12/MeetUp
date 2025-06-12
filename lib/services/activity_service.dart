import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meetup/utils/constants.dart';
import '../models/activity_model.dart';

class ActivityService {
  final url = Constants.activities;

  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() => _storage.read(key: 'jwt_token');

  Future<List<ActivityModel>> getByEvent(String eventId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$url/event/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );


    if (res.statusCode != 200) {
      throw Exception('Error al cargar actividades');
    }

    final decoded = jsonDecode(res.body);
    final list = decoded['data'] as List<dynamic>;

    return list.map((a) => ActivityModel.fromJson(a)).toList();
  }

  Future<void> create(ActivityModel activity) async {
    final token = await _getToken();
    await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
    );
  }

  Future<void> update(ActivityModel activity) async {
    final token = await _getToken();
    await http.put(
      Uri.parse('$url/${activity.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
    );
  }

  Future<void> delete(String id) async {
    final token = await _getToken();
    await http.delete(
      Uri.parse('$url/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
