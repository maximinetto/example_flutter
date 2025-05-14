import 'package:example_flutter/services/auth_service.dart';
import 'package:flutter/widgets.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  bool _loading = false;
  bool _authenticated = false;

  AuthProvider(this._service) : super();

  get isLoading => _loading;
  get isAuthenticated => _authenticated;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _authenticated = await _service.isAuthenticated();
    _loading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _service.login(email, password);
    _authenticated = await _service.isAuthenticated();
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}
