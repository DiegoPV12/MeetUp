class Constants {
  // URL Base
  // Usa --dart-define=API_BASE_URL para apuntar a otro entorno.
  // Valor por defecto pensado para ejecución local.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  // Endpoints completos
  static const String loginUrl = '$baseUrl/api/users/login';
  static const String registerUrl = '$baseUrl/api/users/register';
  static const String meUrl = '$baseUrl/api/users/me';
  static const String events = '$baseUrl/api/events';
  static const String tasks = '$baseUrl/api/tasks';
  static const String expenses = '$baseUrl/api/expenses';
  static const String guests = '$baseUrl/api/guests';
  static const String activities = '$baseUrl/api/activities';
  static const String users = '$baseUrl/api/users';

  // Headers comunes
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
