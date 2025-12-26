import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

class AuthService {
  Future<LoginResponse> login(LoginRequest request) async {
    return LoginResponse(token: 'showcase-token');
  }

  Future<void> register(RegisterRequest request) async {
    return;
  }
}
