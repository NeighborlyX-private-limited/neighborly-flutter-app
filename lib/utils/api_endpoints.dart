class ApiEndPoints {
  static const String baseUrl = 'http://localhost:5000/user';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'register'; // dekhna hai
  final String loginEmail = 'login';
}
