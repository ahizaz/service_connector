import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/order/model/all_orders_response_model.dart';

class OrderRepository {
  /// Get all orders for the service provider
  Future<AllOrdersResponse> getAllOrders() async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Fetching all orders...');
      debugPrint('URL: ${Url.getAllorder}');
      debugPrint('Token: ${token.substring(0, 10)}...');
      debugPrint('=================================');

      // Make API call
      final response = await http.get(
        Uri.parse(Url.getAllorder),
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
        return AllOrdersResponse.fromJson(data);
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to fetch orders';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      rethrow;
    }
  }

  /// Get orders with pagination
  Future<AllOrdersResponse> getOrdersWithPagination(String url) async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Authorization token not found. Please login again.');
      }

      debugPrint('=================================');
      debugPrint('Fetching paginated orders...');
      debugPrint('URL: $url');
      debugPrint('=================================');

      // Make API call
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('=================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AllOrdersResponse.fromJson(data);
      } else {
        // Handle error response
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        final errorMessage =
            errorData?['message'] ??
            errorData?['detail'] ??
            'Failed to fetch orders';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error fetching paginated orders: $e');
      rethrow;
    }
  }
}
