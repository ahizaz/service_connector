import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/offer/model/offer_list_model.dart';

class OfferListController extends GetxController {
  final RxList<OfferModel> allOffers = <OfferModel>[].obs;
  final RxList<OfferModel> acceptedOffers = <OfferModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOffers();
  }

  Future<void> fetchAllOffers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      EasyLoading.show(status: 'Loading offers...');

      debugPrint('=================================');
      debugPrint('📥 Fetching all offers');
      debugPrint('API URL: ${Url.getAllofferlist}');

      // Get token from AuthService
      final token = await AuthService.getToken();
      debugPrint('🔑 Token: ${token != null ? "Present" : "Missing"}');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse(Url.getAllofferlist),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📊 Response Status Code: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final offerListResponse = OfferListResponse.fromJson(jsonData);

        allOffers.value = offerListResponse.results;
        
        // Filter only accepted offers with PAID payment status and NOT canceled
        acceptedOffers.value = offerListResponse.results
            .where((offer) => offer.isAccepted && offer.isPaid && !offer.isCanceled)
            .toList();

        debugPrint('✅ Total offers: ${allOffers.length}');
        debugPrint('✅ Accepted offers: ${acceptedOffers.length}');
        debugPrint('=================================');

        EasyLoading.dismiss();
      } else {
        debugPrint('❌ Error: Failed to fetch offers');
        debugPrint('=================================');
        
        EasyLoading.dismiss();
        throw Exception('Failed to load offers: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      debugPrint('=================================');
      
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      EasyLoading.dismiss();
      
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOffers() async {
    await fetchAllOffers();
  }

  void clearData() {
    allOffers.clear();
    acceptedOffers.clear();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
