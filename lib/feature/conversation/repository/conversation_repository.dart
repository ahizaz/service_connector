import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/conversation/model/conversation_create_request_model.dart';
import 'package:service_connect/feature/conversation/model/conversation_response_model.dart';
import 'package:service_connect/feature/conversation/model/conversation_list_response_model.dart';
import 'package:service_connect/feature/conversation/model/message_response_model.dart';

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
        final errorMessage =
            errorData?['message'] ??
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
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to create conversation';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      rethrow;
    }
  }

  /// Accept or decline conversation
  Future<void> updateConversationStatus(
    int conversationId,
    String action,
  ) async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Updating conversation status');
      debugPrint('Conversation ID: $conversationId');
      debugPrint('Action: $action');
      debugPrint('URL: ${Url.acceptdeclineConversation(conversationId)}');
      debugPrint('Token: ${token.substring(0, 10)}...');
      debugPrint('=================================');

      // Create request body
      final requestBody = jsonEncode({'action': action});
      debugPrint('Request body: $requestBody');

      // Make API call
      final response = await http.patch(
        Uri.parse(Url.acceptdeclineConversation(conversationId)),
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
        debugPrint('Conversation status updated successfully');
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to update conversation status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error updating conversation status: $e');
      rethrow;
    }
  }

  /// Get messages for a specific conversation
  Future<MessageResponse> getConversationMessages(int conversationId) async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Fetching messages for conversation: $conversationId');
      debugPrint('URL: ${Url.getSpecificConversation(conversationId)}');
      debugPrint('Token: ${token.substring(0, 10)}...');
      debugPrint('=================================');

      // Make API call
      final response = await http.get(
        Uri.parse(Url.getSpecificConversation(conversationId)),
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
        return MessageResponse.fromJson(data);
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to fetch messages';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      rethrow;
    }
  }

  /// Send message with optional image and file attachments
  Future<void> sendMessage({
    required int conversationId,
    String? messageText,
    File? messageImage,
    File? messageFile,
  }) async {
    try {
      EasyLoading.show(status: 'Sending...');

      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Sending message to conversation: $conversationId');
      debugPrint('URL: ${Url.sendMessage}');
      debugPrint('Bearer Token: $token');
      debugPrint('Message Text: $messageText');
      debugPrint('Has Image: ${messageImage != null}');
      debugPrint('Has File: ${messageFile != null}');
      debugPrint('=================================');

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(Url.sendMessage));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add conversation ID
      request.fields['conversation'] = conversationId.toString();

      // Add message text if provided
      if (messageText != null && messageText.isNotEmpty) {
        request.fields['message_text'] = messageText;
      }

      // Add image if provided
      if (messageImage != null) {
        final imageStream = http.ByteStream(messageImage.openRead());
        final imageLength = await messageImage.length();
        final imageName = messageImage.path.split('/').last;

        final multipartFile = http.MultipartFile(
          'message_image',
          imageStream,
          imageLength,
          filename: imageName,
        );

        request.files.add(multipartFile);
        debugPrint('Added image: $imageName');
      }

      // Add file if provided
      if (messageFile != null) {
        final fileStream = http.ByteStream(messageFile.openRead());
        final fileLength = await messageFile.length();
        final fileName = messageFile.path.split('/').last;

        final multipartFile = http.MultipartFile(
          'message_file',
          fileStream,
          fileLength,
          filename: fileName,
        );

        request.files.add(multipartFile);
        debugPrint('Added file: $fileName');
      }

      debugPrint('Sending request...');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('=================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        debugPrint('Message sent successfully');
      } else {
        EasyLoading.dismiss();
        // Handle error response
        final Map<String, dynamic>? errorData = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to send message';
        throw Exception(errorMessage);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }
}
