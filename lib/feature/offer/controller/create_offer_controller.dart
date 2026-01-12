import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/offer/model/create_offer_model.dart';

class CreateOfferController extends GetxController {
  late TextEditingController serviceDescriptionController;
  late TextEditingController serviceCostController;
  late TextEditingController serviceTimelineController;
  late TextEditingController termsConditionsController;

  final RxInt selectedServiceCategory = 0.obs;
  final RxString selectedUrgencyType = 'normal'.obs;

  final List<String> serviceCategories = [
    'Cleaning',
    'Concrete',
    'Electrical',
    'Handyperson',
    'HVAC',
    'Landscaping',
    'Painting',
    'Plumbing',
    'Remodeling',
    'Roofing',
    'Windows',
  ];

  final List<String> urgencyTypes = ['normal', 'urgent', 'asap'];

  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    serviceDescriptionController = TextEditingController(
      text: 'Build responsive website',
    );
    serviceCostController = TextEditingController(text: '500.00');
    serviceTimelineController = TextEditingController(text: '5 days');
    termsConditionsController = TextEditingController(
      text: 'Payment on completion',
    );

    // Add listeners for validation
    serviceDescriptionController.addListener(_validateForm);
    serviceCostController.addListener(_validateForm);
    serviceTimelineController.addListener(_validateForm);
    termsConditionsController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value =
        selectedServiceCategory.value > 0 &&
        serviceDescriptionController.text.isNotEmpty &&
        serviceCostController.text.isNotEmpty &&
        serviceTimelineController.text.isNotEmpty &&
        termsConditionsController.text.isNotEmpty;
  }

  void selectCategory(int index) {
    selectedServiceCategory.value = index + 1; // 1-based indexing
    _validateForm();
  }

  void selectUrgencyType(String type) {
    selectedUrgencyType.value = type;
  }

  Future<void> submitOffer() async {
    if (!isFormValid.value) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    try {
      EasyLoading.show(status: 'Creating offer...');

      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        Get.snackbar(
          'Authentication Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
        );
        return;
      }

      final offerModel = CreateOfferModel(
        serviceCategory: selectedServiceCategory.value,
        serviceDescription: serviceDescriptionController.text.trim(),
        serviceCost: serviceCostController.text.trim(),
        serviceTimeline: serviceTimelineController.text.trim(),
        termsConditions: termsConditionsController.text.trim(),
        urgencyType: selectedUrgencyType.value,
      );

      debugPrint('Creating offer with data: ${offerModel.toJson()}');

      final response = await http.post(
        Uri.parse(Url.createOffer),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(offerModel.toJson()),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close the form
        Get.snackbar(
          'Success',
          'Offer created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        String message = 'Failed to create offer';
        try {
          final Map<String, dynamic> resp = jsonDecode(response.body);
          if (resp.containsKey('detail')) message = resp['detail'].toString();
          if (resp.containsKey('message')) message = resp['message'].toString();
        } catch (_) {}

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error creating offer: $e');
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    serviceDescriptionController.dispose();
    serviceCostController.dispose();
    serviceTimelineController.dispose();
    termsConditionsController.dispose();
    super.onClose();
  }
}
