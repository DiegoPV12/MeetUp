import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../utils/constants.dart';

class AuthService {
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse(Constants.loginUrl);
    final response = await http.post(
      url,
      headers: Constants.jsonHeaders,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login fallido: ${response.body}');
    }
  }

  Future<void> register(RegisterRequest request) async {
    final url = Uri.parse(Constants.registerUrl);
    final response = await http.post(
      url,
      headers: Constants.jsonHeaders,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Registro fallido: ${response.body}');
    }
  }
}
