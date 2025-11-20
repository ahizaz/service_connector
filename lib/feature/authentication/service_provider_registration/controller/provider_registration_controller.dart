import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderRegistrationController extends GetxController {
  // Step 1: Professional Profile Setup
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final RxList<File> portfolioImages = <File>[].obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  
  // Step 2: Services Offered
  final TextEditingController serviceCategoryController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final TextEditingController experienceController = TextEditingController();
  
  // Step 3: Work Location
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final RxString selectedLocation = ''.obs;
  
  // Step 4: Documents
  final Rx<File?> tradeLicenseDoc = Rx<File?>(null);
  final Rx<File?> insuranceDoc = Rx<File?>(null);
  
  final ImagePicker _picker = ImagePicker();
  
  // Validation states
  final RxBool isStep1Valid = false.obs;
  final RxBool isStep2Valid = false.obs;
  final RxBool isStep3Valid = false.obs;
  final RxBool isStep4Valid = false.obs;
  
  final RxInt currentStep = 0.obs;
  
  final List<String> serviceCategories = [
    'Service Category',
    'AC Service',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Painting',
    'HVAC',
    'Gardening',
  ];
  
  final List<String> locations = [
    'Location',
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
  ];
  
  @override
  void onInit() {
    super.onInit();
    fullNameController.addListener(_validateStep1);
    professionController.addListener(_validateStep1);
    bioController.addListener(_validateStep1);
    
    experienceController.addListener(_validateStep2);
    
    addressController.addListener(_validateStep3);
    cityController.addListener(_validateStep3);
  }
  
  void _validateStep1() {
    isStep1Valid.value = fullNameController.text.isNotEmpty &&
        professionController.text.isNotEmpty &&
        bioController.text.isNotEmpty;
  }
  
  void _validateStep2() {
    isStep2Valid.value = selectedCategories.isNotEmpty &&
        experienceController.text.isNotEmpty;
  }
  
  void _validateStep3() {
    isStep3Valid.value = selectedLocation.value.isNotEmpty &&
        addressController.text.isNotEmpty &&
        cityController.text.isNotEmpty;
  }
  
  void _validateStep4() {
    isStep4Valid.value = tradeLicenseDoc.value != null &&
        insuranceDoc.value != null;
  }
  
  // Image picking methods
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = File(image.path);
        _validateStep1();
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }
  
  Future<void> pickPortfolioImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        for (var image in images) {
          if (portfolioImages.length < 4) {
            portfolioImages.add(File(image.path));
          }
        }
        _validateStep1();
      }
    } catch (e) {
      _showError('Failed to pick images: $e');
    }
  }
  
  Future<void> pickDocument(String docType) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        if (docType == 'trade') {
          tradeLicenseDoc.value = File(image.path);
        } else if (docType == 'insurance') {
          insuranceDoc.value = File(image.path);
        }
        _validateStep4();
      }
    } catch (e) {
      _showError('Failed to pick document: $e');
    }
  }
  
  void removePortfolioImage(int index) {
    portfolioImages.removeAt(index);
    _validateStep1();
  }
  
  void removeDocument(String docType) {
    if (docType == 'trade') {
      tradeLicenseDoc.value = null;
    } else if (docType == 'insurance') {
      insuranceDoc.value = null;
    }
    _validateStep4();
  }
  
  void selectCategory(String category) {
    if (category != 'Service Category') {
      selectedCategory.value = category;
      if (!selectedCategories.contains(category)) {
        selectedCategories.add(category);
      }
      _validateStep2();
    }
  }
  
  void removeCategory(String category) {
    selectedCategories.remove(category);
    _validateStep2();
  }
  
  void selectLocation(String location) {
    if (location != 'Location') {
      selectedLocation.value = location;
      locationController.text = location;
      _validateStep3();
    }
  }
  
  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }
  
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
  
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  Future<void> completeRegistration() async {
    // Save registration completion status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('provider_registration_completed', true);
    
    Get.snackbar(
      'Success',
      'Registration completed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    professionController.dispose();
    bioController.dispose();
    serviceCategoryController.dispose();
    experienceController.dispose();
    locationController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
