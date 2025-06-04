class Constants {
  // URL Base
  static const String baseUrl = 'https://meetup-backend-nsxu.onrender.com';

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
