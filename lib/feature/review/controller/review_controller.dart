import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/review/model/review_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewController extends GetxController {
  final TextEditingController reviewTextController = TextEditingController();
  final RxInt selectedRating = 0.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }

  void setRating(int rating) {
    selectedRating.value = rating;
    debugPrint('=================================');
    debugPrint('Rating selected: $rating');
    debugPrint('=================================');
  }

  Future<void> submitReview({
    required String providerUserUuid,
    required int orderId,
  }) async {
    try {
      // Validate inputs
      if (selectedRating.value == 0) {
        EasyLoading.showError('Please select a rating');
        debugPrint('❌ Validation failed: No rating selected');
        return;
      }

      final reviewText = reviewTextController.text.trim();
      if (reviewText.isEmpty) {
        EasyLoading.showError('Please enter your review');
        debugPrint('❌ Validation failed: Review text is empty');
        return;
      }

      isSubmitting.value = true;
      EasyLoading.show(status: 'Submitting review...');

      debugPrint('=================================');
      debugPrint('📤 SUBMITTING REVIEW');
      debugPrint('Provider User UUID: $providerUserUuid');
      debugPrint('Order ID: $orderId');
      debugPrint('Rating: ${selectedRating.value}');
      debugPrint('Review Text: $reviewText');
      debugPrint('=================================');

      // Get token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? AuthService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token is missing');
        EasyLoading.dismiss();
        isSubmitting.value = false;
        Get.snackbar(
          'Error',
          'Authentication token is missing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create request model
      final reviewRequest = ReviewRequestModel(
        providerUserUuid: providerUserUuid,
        order: orderId,
        rating: selectedRating.value,
        reviewText: reviewText,
      );

      debugPrint('📍 API URL: ${Url.receiverReview}');
      debugPrint('📦 Request Body: ${jsonEncode(reviewRequest.toJson())}');

      // Make API call
      final response = await http.post(
        Uri.parse(Url.receiverReview),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reviewRequest.toJson()),
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isSubmitting.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Review submitted successfully');

        EasyLoading.showSuccess('Review submitted successfully!');
        
        // Clear form
        reviewTextController.clear();
        selectedRating.value = 0;

        // Navigate back after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });

        Get.snackbar(
          'Success',
          'Your review has been submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        debugPrint('❌ Failed to submit review');
        
        // Try to parse error message
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['detail'] ?? 
                             errorData['message'] ?? 
                             'Failed to submit review';
          
          EasyLoading.showError(errorMessage);
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } catch (e) {
          EasyLoading.showError('Failed to submit review');
          Get.snackbar(
            'Error',
            'Failed to submit review',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('❌ Exception occurred while submitting review');
      debugPrint('Error: $e');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isSubmitting.value = false;

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
