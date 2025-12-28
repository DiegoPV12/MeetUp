import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import 'showcase_data.dart';

class AuthService {
  Future<LoginResponse> login(LoginRequest request) async {
    final user = ShowcaseData.findUserByEmail(request.email);
    if (user == null || user.password != request.password) {
      throw Exception('Credenciales inválidas');
    }

    ShowcaseData.currentUser = user.profile;
    return LoginResponse(token: 'showcase-token');
  }

  Future<void> register(RegisterRequest request) async {
    ShowcaseData.registerUser(
      name: request.name,
      email: request.email,
      password: request.password,
    );
  }
}
