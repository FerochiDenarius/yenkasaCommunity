// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/refresh_token_request.dart';
import '../models/token_response.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://api.yenkasacom.com/api/",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {"Content-Type": "application/json"},
  ));

  // ✅ Register user
  Future<LoginResponse> registerUser(RegisterRequest request) async {
    final response = await _dio.post("auth/register", data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  // ✅ Login
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post("auth/login", data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  // ✅ Request email verification
  Future<Map<String, dynamic>> requestEmailVerification(String email) async {
    final response = await _dio.post("auth/verify/request", data: {"email": email});
    return response.data;
  }

  // ✅ Request phone verification
  Future<Map<String, dynamic>> requestPhoneVerification(String phone) async {
    final response = await _dio.post("auth/verify/request-phone", data: {"phone": phone});
    return response.data;
  }

  // ✅ Confirm verification
  Future<Map<String, dynamic>> confirmVerification(String code, String userId) async {
    final response = await _dio.post("auth/verify/confirm", data: {"code": code, "userId": userId});
    return response.data;
  }

  // ✅ Update FCM token
  Future<void> updateFcmToken(String userId, String token) async {
    await _dio.patch("users/$userId/fcm-token", data: {"fcmToken": token});
  }

  // ✅ Update OneSignal Player ID
  Future<void> updatePlayerId(String userId, String playerId) async {
    await _dio.patch("users/$userId/player-id", data: {"playerId": playerId});
  }

  // ✅ Refresh token
  Future<TokenResponse> refreshToken(RefreshTokenRequest request) async {
    final response = await _dio.post("auth/token/refresh", data: request.toJson());
    return TokenResponse.fromJson(response.data);
  }
}
