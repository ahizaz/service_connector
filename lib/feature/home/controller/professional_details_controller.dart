import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/home/model/provider_detail_model.dart';
import 'package:service_connect/feature/home/repository/provider_repositroy.dart';
import 'package:service_connect/feature/review/model/provider_reviews_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionalDetailsController extends GetxController {
  final ProviderRepository _providerRepository = ProviderRepository();

  final Rx<ProviderDetailModel?> providerDetail = Rx<ProviderDetailModel?>(
    null,
  );
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoadingReviews = false.obs;

  final int professionalId;

  ProfessionalDetailsController({required this.professionalId});

  @override
  void onInit() {
    super.onInit();
    _fetchProviderDetails();
  }

  Future<void> fetchProviderReviews(String providerUserId) async {
    try {
      debugPrint('=================================');
      debugPrint('Fetching reviews for provider: $providerUserId');
      debugPrint('=================================');

      isLoadingReviews.value = true;
      EasyLoading.show(status: 'Loading reviews...');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final url = Url.getProviderReviews(providerUserId);
      debugPrint('Request URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reviewsResponse = ProviderReviewsResponse.fromJson(data);

        reviews.value = reviewsResponse.results;
        debugPrint('=================================');
        debugPrint('✅ Reviews loaded successfully');
        debugPrint('Total reviews: ${reviewsResponse.count}');
        debugPrint('=================================');
      } else {
        debugPrint('❌ Error: ${response.statusCode}');
        throw Exception('Failed to load reviews');
      }

      isLoadingReviews.value = false;
      EasyLoading.dismiss();
    } catch (e) {
      debugPrint('=================================');
      debugPrint('❌ Exception loading reviews: $e');
      debugPrint('=================================');

      isLoadingReviews.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> _fetchProviderDetails() async {
    try {
      debugPrint('=================================');
      debugPrint('Starting to fetch provider details for ID: $professionalId');
      debugPrint('=================================');

      EasyLoading.show(status: 'Loading...');

      final details = await _providerRepository.getProviderDetails(
        professionalId,
      );

      debugPrint('=================================');
      debugPrint('Provider details loaded successfully');
      debugPrint('Provider Name: ${details.user.name}');
      debugPrint('Service Title: ${details.serviceTitle}');
      debugPrint('Rating: ${details.providerRating}');
      debugPrint('=================================');

      providerDetail.value = details;
      isLoading.value = false;

      EasyLoading.dismiss();

      // Fetch reviews after provider details are loaded
      if (details.user.id.isNotEmpty) {
        fetchProviderReviews(details.user.id);
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('Error loading provider details: $e');
      debugPrint('=================================');

      errorMessage.value = e.toString();
      isLoading.value = false;

      EasyLoading.dismiss();
      EasyLoading.showError('Failed to load provider details');
    }
  }

  void retryFetch() {
    isLoading.value = true;
    errorMessage.value = '';
    _fetchProviderDetails();
  }
}
