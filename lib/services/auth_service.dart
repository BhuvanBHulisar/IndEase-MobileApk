import 'api_service.dart';
import '../constants/api.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final data = await ApiService.post(
      ApiConstants.login,
      {'email': email, 'password': password},
      auth: false,
    );
    await ApiService.saveToken(data['token'] ?? data['accessToken']);
    return data;
  }

  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> userData) async {
    userData['role'] = 'consumer';
    final data = await ApiService.post(
      ApiConstants.register,
      userData,
      auth: false,
    );
    await ApiService.saveToken(data['token'] ?? data['accessToken']);
    return data;
  }

  static Future<Map<String, dynamic>> getMe() async {
    return await ApiService.get(ApiConstants.me);
  }

  static Future<void> logout() async {
    try {
      await ApiService.post(ApiConstants.logout, {});
    } catch (_) {}
    await ApiService.clearToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}
