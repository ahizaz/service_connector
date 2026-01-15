import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';

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
