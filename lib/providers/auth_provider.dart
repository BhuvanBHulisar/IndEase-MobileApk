import 'package:flutter/foundation.dart';

import '../constants/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _firstName = mockUserFirstName;
  String _lastName = mockUserLastName;
  String _email = mockUserEmail;

  bool get isAuthenticated => _isAuthenticated;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName';
  String get email => _email;

  void login({
    required String email,
    required String password,
  }) {
    _email = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  void demoLogin() {
    _firstName = 'Amit';
    _lastName = 'Kumar';
    _email = demoEmail;
    _isAuthenticated = true;
    notifyListeners();
  }

  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
