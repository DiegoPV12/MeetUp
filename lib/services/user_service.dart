import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/constants.dart';

class UserService {
  final _storage = const FlutterSecureStorage();

  Future<UserModel> fetchUserProfile() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse(Constants.meUrl),
      headers: {'Authorization': 'Bearer $token', ...Constants.jsonHeaders},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Error al obtener perfil');
    }
  }
}
