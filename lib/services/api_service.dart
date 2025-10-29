// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/post.dart';
import '../models/chat_room.dart';

class ApiService {
  final Dio _dio = ApiClient.dio;

  // ✅ Login
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post("auth/login", data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  // ✅ Fetch all posts
  Future<List<Post>> getAllPosts() async {
    final response = await _dio.get("posts");
    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  }

  // ✅ Fetch user's own posts
  Future<List<Post>> getMyPosts() async {
    final response = await _dio.get("posts/my");
    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  }

  // ✅ Like a post
  Future<void> toggleLike(String postId) async {
    await _dio.post("social/like/$postId");
  }

  // ✅ Comment on post
  Future<void> addComment(String postId, String comment) async {
    await _dio.post("social/comment/$postId", data: {"text": comment});
  }

  // ✅ Get all chat rooms
  Future<List<ChatRoom>> getChatRooms() async {
    final response = await _dio.get("chatrooms");
    return (response.data as List).map((e) => ChatRoom.fromJson(e)).toList();
  }

  // ✅ Create chat room
  Future<void> createChatRoom(String receiverId) async {
    await _dio.post("chatroom/$receiverId");
  }

  // ✅ Send message
  Future<void> sendMessage(String roomId, String message) async {
    await _dio.post("messages", data: {"roomId": roomId, "message": message});
  }
}
