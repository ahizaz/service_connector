import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/service_receiver/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      debugPrint('=================================');
      debugPrint('Fetching all categories...');
      debugPrint('URL: ${Url.getAllcatagories}');
      debugPrint('Token: $token');
      debugPrint('=================================');

      final response = await http.get(
        Uri.parse(Url.getAllcatagories),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('=================================');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        
        debugPrint('=================================');
        debugPrint('Categories fetched successfully!');
        debugPrint('Total categories: ${categories.length}');
        debugPrint('=================================');
        
        return categories;
      } else {
        debugPrint('=================================');
        debugPrint('Failed to fetch categories');
        debugPrint('Status code: ${response.statusCode}');
        debugPrint('=================================');
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('Error fetching categories: $e');
      debugPrint('=================================');
      rethrow;
    }
  }
}
