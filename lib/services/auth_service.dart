import 'package:example_flutter/errors/invalid_credentials_exception.dart';

const validEmail = "maximinetto@gmail.com";

class AuthService {
  bool _authenticated = false;

  Future<bool> isAuthenticated() async {
    return _authenticated;
  }

  Future<void> login(String email, String password) async {
    if (email == validEmail && password == "12345678") {
      _authenticated = true;
    } else {
      _authenticated = false;
      throw InvalidCredentialsException("Invalid credentials");
    }
  }

  Future<void> logout() async {
    _authenticated = false;
  }
}
