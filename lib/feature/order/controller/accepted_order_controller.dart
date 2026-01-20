import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/order/model/accepted_order_model.dart';

class AcceptedOrderController extends GetxController {
  final RxList<AcceptedOrderModel> acceptedOrders = <AcceptedOrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch all accepted orders for a specific receiver user
  Future<void> fetchAcceptedOrders(String receiverUserId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading orders...');

      debugPrint('=================================');
      debugPrint('📥 FETCHING ACCEPTED ORDERS');
      debugPrint('Receiver User ID: $receiverUserId');
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
        isLoading.value = false;
        return;
      }

      final url = Url.allacceptedOrder(receiverUserId);
      debugPrint('📍 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isLoading.value = false;

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        debugPrint('✅ Successfully fetched ${jsonData.length} accepted orders');
        
        // Filter only paid orders
        acceptedOrders.value = jsonData
            .map((json) => AcceptedOrderModel.fromJson(json))
            .where((order) => order.paymentStatus.toLowerCase() == 'paid')
            .toList();

        debugPrint('=================================');
        debugPrint('📋 PAID ACCEPTED ORDERS LIST (Filtered)');
        debugPrint('Total Orders Fetched: ${jsonData.length}');
        debugPrint('Paid Orders: ${acceptedOrders.length}');
        for (var order in acceptedOrders) {
          debugPrint('Quotation ID: ${order.quotationId}');
          debugPrint('Service Category: ${order.serviceCategory} (${order.getCategoryName()})');
          debugPrint('Cost: \$${order.serviceCost}');
          debugPrint('Payment Status: ${order.paymentStatus}');
          debugPrint('Timeline: ${order.serviceTimeline}');
          debugPrint('Created: ${order.createdAt}');
          debugPrint('---');
        }
        debugPrint('=================================');

        if (acceptedOrders.isEmpty) {
          Get.snackbar(
            'Info',
            'No paid accepted orders found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        }
      } else {
        debugPrint('❌ Failed to fetch accepted orders');
        debugPrint('Error: ${response.body}');
        
        Get.snackbar(
          'Error',
          'Failed to load accepted orders',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('❌ EXCEPTION OCCURRED');
      debugPrint('Error: $e');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
