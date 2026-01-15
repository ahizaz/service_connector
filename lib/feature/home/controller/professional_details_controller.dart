import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/home/model/provider_detail_model.dart';
import 'package:service_connect/feature/home/repository/provider_repositroy.dart';

class ProfessionalDetailsController extends GetxController {
  final ProviderRepository _providerRepository = ProviderRepository();
  
  final Rx<ProviderDetailModel?> providerDetail = Rx<ProviderDetailModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  final int professionalId;

  ProfessionalDetailsController({required this.professionalId});

  @override
  void onInit() {
    super.onInit();
    _fetchProviderDetails();
  }

  Future<void> _fetchProviderDetails() async {
    try {
      debugPrint('=================================');
      debugPrint('Starting to fetch provider details for ID: $professionalId');
      debugPrint('=================================');
      
      EasyLoading.show(status: 'Loading...');
      
      final details = await _providerRepository.getProviderDetails(professionalId);
      
      debugPrint('=================================');
      debugPrint('Provider details loaded successfully');
      debugPrint('Provider Name: ${details.user.name}');
      debugPrint('Service Title: ${details.serviceTitle}');
      debugPrint('Rating: ${details.providerRating}');
      debugPrint('=================================');
      
      providerDetail.value = details;
      isLoading.value = false;
      
      EasyLoading.dismiss();
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
