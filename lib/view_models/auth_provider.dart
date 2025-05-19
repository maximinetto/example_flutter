import 'dart:async';

import 'package:example_flutter/services/auth_service.dart';
import 'package:flutter/widgets.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  bool _loading = false;
  bool _authenticated = false;
  Timer? _inactivityTimer;

  AuthProvider(this._service);

  bool get isLoading => _loading;
  bool get isAuthenticated => _authenticated;

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
    _startInactivityTimer();
  }

  Future<void> logout() async {
    _cancelInactivityTimer();
    await _service.logout();
    _authenticated = await _service.isAuthenticated();
    notifyListeners();
  }

  void userActivityDetected() {
    if (_authenticated) {
      _startInactivityTimer();
    }
  }

  void _startInactivityTimer() {
    _cancelInactivityTimer();
    _inactivityTimer = Timer(const Duration(minutes: 15), () {
      logout(); // No usa context
    });
  }

  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  @override
  void dispose() {
    _cancelInactivityTimer();
    super.dispose();
  }
}
