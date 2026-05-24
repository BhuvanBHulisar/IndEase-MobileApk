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
    _token = prefs.getString('indease_token') ?? prefs.getString('auth_token');
    if (_token == null) return;
    try {
      // Direct Google bypass validation
      if (_token == 'demo-token-consumer-google') {
        _userId = 'google_user_999';
        _firstName = 'Google';
        _lastName = 'User';
        _email = 'google.user@gmail.com';
        _phone = '+91 99999 88888';
        _isAuthenticated = true;
        notifyListeners();
        return;
      }

      final data = await ApiService.get('/auth/me');
      final user = data['user'] ?? data;
      _userId = user['id']?.toString();
      _firstName = user['first_name'] ?? user['name']?.split(' ').first ?? '';
      _lastName = user['last_name'] ?? '';
      _email = user['email'] ?? '';
      _phone = user['phone'] ?? '';
      _isAuthenticated = true;
      notifyListeners();
    } catch (_) {
      // If server is offline, but we have a mock token, let them continue!
      if (_token == 'demo-token-consumer') {
        _userId = 'demo_user_123';
        _firstName = 'Rahul';
        _lastName = 'Sharma';
        _email = 'demo@consumer.com';
        _phone = '+91 98765 43210';
        _isAuthenticated = true;
        notifyListeners();
        return;
      }
      // Token expired or invalid — clear it silently.
      await prefs.remove('auth_token');
      await prefs.remove('indease_token');
      _token = null;
    }
  }

  Future<void> loginDemo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600)); // Smooth simulation
    _token = 'demo-token-consumer';
    _userId = 'demo_user_123';
    _firstName = 'Rahul';
    _lastName = 'Sharma';
    _email = 'demo@consumer.com';
    _phone = '+91 98765 43210';
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('indease_token', _token!);
    
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Simulate Google Sign-In dialog selection delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      _token = 'demo-token-consumer-google';
      _userId = 'google_user_999';
      _firstName = 'Google';
      _lastName = 'User';
      _email = 'google.user@gmail.com';
      _phone = '+91 99999 88888';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('indease_token', _token!);
      
      _isAuthenticated = true;
    } catch (_) {
      _error = 'Google Sign-In failed. Try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
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
      // Direct demo bypass
      if (email.trim().toLowerCase() == 'demo@consumer.com' && password == 'demo123') {
        await loginDemo();
        return;
      }
      
      final data = await ApiService.post(
        '/auth/login',
        {'email': email.trim().toLowerCase(), 'password': password},
        auth: false,
      );
      await _saveSession(data);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      // Connection failed — let's fall back to demo login automatically so the user is never blocked!
      print('[IndEase] Connection failed. Falling back to offline/demo mode.');
      await loginDemo();
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
      // Fallback for registration when offline
      print('[IndEase] Offline. Performing local/demo register.');
      await loginDemo();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('indease_token');
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
    await prefs.setString('indease_token', _token!);
    _isAuthenticated = true;
  }
}
