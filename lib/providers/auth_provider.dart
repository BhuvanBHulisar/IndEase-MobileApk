import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String? _token;
  String? _userId;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName'.trim();
  String get email => _email;
  String get phone => _phone;
  String? get error => _error;
  String? get token => _token;
  String? get userId => _userId;

  /// Called on app startup to restore an existing JWT session.
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token == null) return;
    try {
      final data = await ApiService.get('/auth/me');
      _userId = data['id']?.toString();
      _firstName = data['first_name'] ?? '';
      _lastName = data['last_name'] ?? '';
      _email = data['email'] ?? '';
      _phone = data['phone'] ?? '';
      _isAuthenticated = true;
      notifyListeners();
    } catch (_) {
      // Token expired or invalid — clear it silently.
      await prefs.remove('auth_token');
      _token = null;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await ApiService.post(
        '/auth/login',
        {'email': email.trim().toLowerCase(), 'password': password},
        auth: false,
      );
      await _saveSession(data);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Connection failed. Check your network.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await ApiService.post(
        '/auth/register',
        {
          'first_name': firstName.trim(),
          'last_name': lastName.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'role': 'consumer',
        },
        auth: false,
      );
      await _saveSession(data);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Registration failed. Try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    _userId = null;
    _isAuthenticated = false;
    _firstName = '';
    _lastName = '';
    _email = '';
    _phone = '';
    notifyListeners();
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    _token = data['token'];
    final user = data['user'] ?? data;
    _userId = user['id']?.toString();
    _firstName = user['first_name'] ?? user['name']?.split(' ').first ?? '';
    _lastName = user['last_name'] ?? '';
    _email = user['email'] ?? '';
    _phone = user['phone'] ?? '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    _isAuthenticated = true;
  }
}
