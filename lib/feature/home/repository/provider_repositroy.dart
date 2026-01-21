import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/home/model/provider_model.dart';
import 'package:service_connect/feature/home/model/provider_detail_model.dart';
import 'package:service_connect/feature/home/model/earnings_model.dart';
import 'package:service_connect/feature/home/model/hiring_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderRepository {

  Future<List<ProviderModel>> getAllProviders() async {
    try {
   
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      // debugPrint console এ message print করে debugging এর জন্য
      debugPrint('=================================');
      debugPrint('Fetching all providers...');
      debugPrint('URL: ${Url.getAllproviders}'); // API URL print করছে
      debugPrint('Token: $token'); // Token print করছে
      debugPrint('=================================');

    
      final response = await http.get(
        Uri.parse(Url.getAllproviders),
        headers: {
          'Content-Type': 'application/json', 
          'Authorization': 'Bearer $token', 
        },
      );

    
      debugPrint('=================================');
      debugPrint('Response status: ${response.statusCode}'); 
      debugPrint('Response body: ${response.body}');
      debugPrint('=================================');

      // যদি API call successful হয় (status code 200 বা 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // response.body হলো String, সেটাকে Map এ convert করছি
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // 'results' key তে provider list আছে
        final List<dynamic> results = data['results'] ?? [];
        
        debugPrint('Total providers found: ${results.length}');
        
    
        return results
            .map((json) => ProviderModel.fromJson(json))
            .toList();
      } else {
       
        debugPrint('Failed to load providers');
        throw Exception('Failed to load providers');
      }
    } catch (e) {
      
      debugPrint('Error fetching providers: $e');
      throw Exception('Error fetching providers: $e');
    }
  }

  // Get provider details by ID
  Future<ProviderDetailModel> getProviderDetails(int providerId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      debugPrint('=================================');
      debugPrint('Fetching provider details for ID: $providerId');
      debugPrint('URL: ${Url.getProviderDetails(providerId)}');
      debugPrint('Token: $token');
      debugPrint('=================================');

      final response = await http.get(
        Uri.parse(Url.getProviderDetails(providerId)),
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
        debugPrint('Provider details fetched successfully');
        return ProviderDetailModel.fromJson(data);
      } else {
        debugPrint('Failed to load provider details');
        throw Exception('Failed to load provider details');
      }
    } catch (e) {
      debugPrint('Error fetching provider details: $e');
      throw Exception('Error fetching provider details: $e');
    }
  }

  // Get provider earnings/dashboard data
  Future<EarningsModel> getEarnings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      debugPrint('=================================');
      debugPrint('Fetching provider earnings...');
      debugPrint('URL: ${Url.getEarnings}');
      debugPrint('Token: $token');
      debugPrint('=================================');

      final response = await http.get(
        Uri.parse(Url.getEarnings),
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
        debugPrint('Earnings data fetched successfully');
        return EarningsModel.fromJson(data);
      } else {
        debugPrint('Failed to load earnings data');
        throw Exception('Failed to load earnings data');
      }
    } catch (e) {
      debugPrint('Error fetching earnings: $e');
      throw Exception('Error fetching earnings: $e');
    }
  }

  // Get provider hiring list
  Future<List<HiringListModel>> getHiringList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      debugPrint('=================================');
      debugPrint('Fetching hiring list...');
      debugPrint('URL: ${Url.getHiringList}');
      debugPrint('Token: $token');
      debugPrint('=================================');

      final response = await http.get(
        Uri.parse(Url.getHiringList),
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
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Hiring list fetched successfully');
        debugPrint('Total hiring records: ${data.length}');
        return data.map((json) => HiringListModel.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load hiring list');
        throw Exception('Failed to load hiring list');
      }
    } catch (e) {
      debugPrint('Error fetching hiring list: $e');
      throw Exception('Error fetching hiring list: $e');
    }
  }
}