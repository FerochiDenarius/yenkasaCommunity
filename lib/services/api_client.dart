// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import '../models/refresh_token_request.dart';
import '../models/token_response.dart';

class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: "https://yenkasa-bldrv.ondigitalocean.app/api/",
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');
        if (token != null && !options.path.contains("login") && !options.path.contains("register")) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle 401 errors (unauthorized)
        if (e.response?.statusCode == 401 &&
            !(e.requestOptions.path.contains('auth/token/refresh'))) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final prefs = await SharedPreferences.getInstance();
            final newToken = prefs.getString('accessToken');
            final opts = e.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final cloneReq = await dio.fetch(opts);
            return handler.resolve(cloneReq);
          }
        }
        return handler.next(e);
      },
      onResponse: (response, handler) {
        print("✅ [${response.statusCode}] ${response.requestOptions.path}");
        handler.next(response);
      },
    ));
  }

  static Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      if (refreshToken == null) return false;

      final authService = AuthService();
      final tokenResponse = await authService.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      await prefs.setString('accessToken', tokenResponse.token);
      await prefs.setString('refreshToken', tokenResponse.refreshToken ?? '');

      return true;
    } catch (e) {
      print("⚠️ Token refresh failed: $e");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      return false;
    }
  }
}
