import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/conversation/model/conversation_create_request_model.dart';
import 'package:service_connect/feature/conversation/model/conversation_response_model.dart';
import 'package:service_connect/feature/conversation/model/conversation_list_response_model.dart';

class ConversationRepository {
  /// Get all conversations (inbox)
  Future<ConversationListResponse> getAllConversations() async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Fetching all conversations...');
      debugPrint('URL: ${Url.getAllConversation}');
      debugPrint('Token: ${token.substring(0, 10)}...');
      debugPrint('=================================');

      // Make API call
      final response = await http.get(
        Uri.parse(Url.getAllConversation),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('=================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ConversationListResponse.fromJson(data);
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage = errorData?['message'] ?? 
                           errorData?['detail'] ?? 
                           'Failed to fetch conversations';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error fetching conversations: $e');
      rethrow;
    }
  }

  /// Create a new conversation with a provider
  Future<ConversationResponse> createConversation(String providerId) async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Creating conversation with provider: $providerId');
      debugPrint('URL: ${Url.createConversation}');
      debugPrint('Token: ${token.substring(0, 10)}...');
      debugPrint('=================================');

      // Create request body
      final request = ConversationCreateRequest(providerId: providerId);
      final requestBody = jsonEncode(request.toJson());

      debugPrint('Request body: $requestBody');

      // Make API call
      final response = await http.post(
        Uri.parse(Url.createConversation),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('=================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ConversationResponse.fromJson(data);
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage = errorData?['message'] ?? 
                           errorData?['detail'] ?? 
                           'Failed to create conversation';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      rethrow;
    }
  }
}
