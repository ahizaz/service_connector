import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/order/model/all_orders_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedOdersController extends GetxController{
  var completedOrders = <OrderModel>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
 
    super.onInit();
    fetchCompletedOrders();
  }
  Future<void>fetchCompletedOrders()async{
    try{
      isLoading.value=true;
      EasyLoading.show(status: 'Loading...');
      debugPrint('=================================');
      debugPrint('Fetching completed orders......');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      debugPrint('Token: ${token != null ? token.substring(0, 10) : 'null'}...');
      debugPrint('URL: ${Url.getAllorder}');
      final response = await http.get( 
        Uri.parse(Url.getAllorder),
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'application/json',
        }
      );
     debugPrint('Response Status Code: ${response.statusCode}');
     debugPrint('Response Body: ${response.body}');
     if(response.statusCode==200){
      final data = json.decode(response.body);
      final allOrdersResponse = AllOrdersResponse.fromJson(data);
       debugPrint('Total orders: ${allOrdersResponse.results.length}');
       final completed = allOrdersResponse.results.where((order)=>order.orderStatus=='completed').toList();
       completedOrders.value=completed;
       debugPrint('Completed orders: ${completed.length}');
       debugPrint('=================================');
       EasyLoading.dismiss();
     }else{
      debugPrint('Error: ${response.statusCode}');
      debugPrint('=================================');
      EasyLoading.dismiss();
          
     }

    }catch(e){
      debugPrint('Exception: $e');
      debugPrint('=================================');
      EasyLoading.dismiss();
    }finally{
      isLoading.value=false;
    }
  }
}