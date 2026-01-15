import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/chat/controller/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderController extends GetxController {
  final TextEditingController serviceTimeTakenController =
      TextEditingController();

  @override
  void onClose() {
    serviceTimeTakenController.dispose();
    super.onClose();
  }

  // Create Order
  Future<void> createOrder({required String quotationId}) async {
    try {
      final serviceTimeTaken = serviceTimeTakenController.text.trim();

      if (serviceTimeTaken.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter service time taken',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      EasyLoading.show(status: 'Creating order...');

      debugPrint('=================================');
      debugPrint('📤 CREATING ORDER');
      debugPrint('Quotation ID: $quotationId');
      debugPrint('Service Time Taken: $serviceTimeTaken');
      debugPrint('=================================');

      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token is missing');
        EasyLoading.dismiss();
        Get.snackbar(
          'Error',
          'Authentication token is missing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Url.createOrder;
      debugPrint('📍 API URL: $url');

      final body = {
        'quotation': int.parse(quotationId),
        'service_time_taken': serviceTimeTaken,
      };

      debugPrint('📦 Request Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Order created successfully');

        // Parse response to get order details
        final responseData = jsonDecode(response.body);
        final orderId = responseData['id'] ?? responseData['order_id'];
        final orderStatus = responseData['order_status'] ?? 'pending';

        // Send WebSocket notification to receiver
        await _sendOrderNotification(
          orderId: orderId,
          quotationId: int.parse(quotationId),
          orderStatus: orderStatus,
          serviceTimeTaken: serviceTimeTaken,
        );

        Get.snackbar(
          'Success',
          'Order created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear the text field
        serviceTimeTakenController.clear();

        // Navigate back twice to go back to the accepted orders screen
        Get.back();
        Get.back();
      } else {
        debugPrint('❌ Failed to create order');
        debugPrint('Error: ${response.body}');

        final errorMessage = _parseErrorMessage(response.body);

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      EasyLoading.dismiss();

      Get.snackbar(
        'Error',
        'Failed to create order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Send order notification through WebSocket
  Future<void> _sendOrderNotification({
    required int orderId,
    required int quotationId,
    required String orderStatus,
    required String serviceTimeTaken,
  }) async {
    try {
      debugPrint('=================================');
      debugPrint('🔌 SENDING ORDER WEBSOCKET NOTIFICATION');
      debugPrint('Order ID: $orderId');
      debugPrint('Quotation ID: $quotationId');
      debugPrint('Order Status: $orderStatus');
      debugPrint('Service Time Taken: $serviceTimeTaken');
      debugPrint('=================================');

      // Get current user info
      final prefs = await SharedPreferences.getInstance();
      final senderId = prefs.getString('userId') ?? '';
      final senderName = prefs.getString('userName') ?? 'Provider';

      // Try to get ChatController instance if it exists
      try {
        final chatController = Get.find<ChatController>();
        
        if (chatController.isWebSocketConnected.value) {
          // Prepare WebSocket message for order
          final webSocketMessage = {
            'type': 'order',
            'message': 'New order created',
            'order_details': {
              'order_id': orderId,
              'quotation_id': quotationId,
              'order_status': orderStatus,
              'service_time_taken': serviceTimeTaken,
            },
            'sender_id': senderId,
            'sender_name': senderName,
            'message_text': '📦 New Order #$orderId has been created',
          };

          debugPrint('📤 Sending WebSocket message: $webSocketMessage');
          
          // Send through WebSocket service
          chatController.sendWebSocketMessage(webSocketMessage);
          
          debugPrint('✅ Order notification sent through WebSocket');
        } else {
          debugPrint('⚠️ WebSocket not connected, notification will be delivered through API polling');
        }
      } catch (e) {
        debugPrint('⚠️ ChatController not found or WebSocket not available: $e');
        debugPrint('✅ Order created via REST API, receiver will see it on refresh');
      }
    } catch (e) {
      debugPrint('❌ Error sending order notification: $e');
      // Don't throw error, order is already created successfully
    }
  }

  String _parseErrorMessage(String responseBody) {
    try {
      final Map<String, dynamic> errorData = jsonDecode(responseBody);
      if (errorData.containsKey('message')) {
        return errorData['message'];
      } else if (errorData.containsKey('error')) {
        return errorData['error'];
      } else {
        return errorData.values.first.toString();
      }
    } catch (e) {
      return 'Failed to create order';
    }
  }
}
