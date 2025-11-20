import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderRegistrationController extends GetxController {
  // Step 1: Professional Profile Setup
  late TextEditingController fullNameController;
  late TextEditingController professionController;
  late TextEditingController bioController;
  final RxList<File> portfolioImages = <File>[].obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  
  // Step 2: Services Offered
  late TextEditingController serviceCategoryController;
  final RxString selectedCategory = ''.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  late TextEditingController serviceTitleController;
  late TextEditingController experienceController;
  late TextEditingController keywordController;
  final RxList<String> keywords = <String>[].obs;
  
  // Step 3: Work Location
  late TextEditingController serviceAreaController;
  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;
  
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
  
  final Map<String, String> countries = {
    'United States': '🇺🇸',
    'United Kingdom': '🇬🇧',
    'Canada': '🇨🇦',
    'Australia': '🇦🇺',
    'Germany': '🇩🇪',
    'France': '🇫🇷',
    'India': '🇮🇳',
    'Japan': '🇯🇵',
    'China': '🇨🇳',
    'Brazil': '🇧🇷',
    'Mexico': '🇲🇽',
    'Spain': '🇪🇸',
    'Italy': '🇮🇹',
    'Netherlands': '🇳🇱',
    'Singapore': '🇸🇬',
    'UAE': '🇦🇪',
    'Saudi Arabia': '🇸🇦',
    'South Korea': '🇰🇷',
    'Bangladesh': '🇧🇩',
    'Pakistan': '🇵🇰',
  };
  
  final Map<String, List<String>> citiesByCountry = {
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'Miami'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Liverpool', 'Leeds', 'Glasgow', 'Edinburgh', 'Bristol', 'Cardiff', 'Belfast'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary', 'Ottawa', 'Edmonton', 'Winnipeg', 'Quebec City', 'Hamilton', 'Victoria'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth', 'Adelaide', 'Gold Coast', 'Canberra', 'Newcastle', 'Hobart', 'Darwin'],
    'Germany': ['Berlin', 'Munich', 'Hamburg', 'Frankfurt', 'Cologne', 'Stuttgart', 'Düsseldorf', 'Dortmund', 'Leipzig', 'Dresden'],
    'France': ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg', 'Montpellier', 'Bordeaux', 'Lille'],
    'India': ['Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Chennai', 'Kolkata', 'Pune', 'Ahmedabad', 'Jaipur', 'Surat'],
    'Japan': ['Tokyo', 'Osaka', 'Yokohama', 'Nagoya', 'Sapporo', 'Fukuoka', 'Kobe', 'Kyoto', 'Hiroshima', 'Sendai'],
    'China': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen', 'Chengdu', 'Hangzhou', 'Wuhan', 'Xian', 'Chongqing', 'Tianjin'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador', 'Fortaleza', 'Belo Horizonte', 'Manaus', 'Curitiba', 'Recife', 'Porto Alegre'],
    'Mexico': ['Mexico City', 'Guadalajara', 'Monterrey', 'Puebla', 'Tijuana', 'León', 'Juárez', 'Zapopan', 'Mérida', 'Cancún'],
    'Spain': ['Madrid', 'Barcelona', 'Valencia', 'Seville', 'Zaragoza', 'Málaga', 'Murcia', 'Palma', 'Bilbao', 'Alicante'],
    'Italy': ['Rome', 'Milan', 'Naples', 'Turin', 'Palermo', 'Genoa', 'Bologna', 'Florence', 'Venice', 'Verona'],
    'Netherlands': ['Amsterdam', 'Rotterdam', 'The Hague', 'Utrecht', 'Eindhoven', 'Tilburg', 'Groningen', 'Almere', 'Breda', 'Nijmegen'],
    'Singapore': ['Singapore City', 'Jurong', 'Woodlands', 'Tampines', 'Bedok', 'Sengkang', 'Hougang', 'Punggol', 'Yishun', 'Bukit Batok'],
    'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman', 'Ras Al Khaimah', 'Fujairah', 'Umm Al Quwain', 'Al Ain', 'Khor Fakkan', 'Dibba'],
    'Saudi Arabia': ['Riyadh', 'Jeddah', 'Mecca', 'Medina', 'Dammam', 'Khobar', 'Tabuk', 'Buraidah', 'Khamis Mushait', 'Abha'],
    'South Korea': ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Daejeon', 'Gwangju', 'Suwon', 'Ulsan', 'Changwon', 'Goyang'],
    'Bangladesh': ['Dhaka', 'Chittagong', 'Khulna', 'Rajshahi', 'Sylhet', 'Barisal', 'Rangpur', 'Comilla', 'Gazipur', 'Narayanganj'],
    'Pakistan': ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Sialkot', 'Gujranwala'],
  };
  
  List<String> get currentCities {
    if (selectedCountry.value.isEmpty) {
      return ['Select your city'];
    }
    final cities = citiesByCountry[selectedCountry.value] ?? [];
    return ['Select your city', ...cities];
  }
  
  @override
  void onInit() {
    super.onInit();
    
    // Initialize TextEditingControllers
    fullNameController = TextEditingController();
    professionController = TextEditingController();
    bioController = TextEditingController();
    serviceCategoryController = TextEditingController();
    serviceTitleController = TextEditingController();
    experienceController = TextEditingController();
    keywordController = TextEditingController();
    serviceAreaController = TextEditingController();
    
    // Add listeners
    fullNameController.addListener(_validateStep1);
    professionController.addListener(_validateStep1);
    
    serviceTitleController.addListener(_validateStep2);
    experienceController.addListener(_validateStep2);
    
    serviceAreaController.addListener(_validateStep3);
  }
  
  void _validateStep1() {
    isStep1Valid.value = fullNameController.text.isNotEmpty &&
        professionController.text.isNotEmpty &&
        profileImage.value != null;
  }
  
  void _validateStep2() {
    isStep2Valid.value = selectedCategories.isNotEmpty &&
        serviceTitleController.text.isNotEmpty &&
        experienceController.text.isNotEmpty &&
        keywords.isNotEmpty;
  }
  
  void _validateStep3() {
    isStep3Valid.value = selectedCountry.value.isNotEmpty &&
        selectedCity.value.isNotEmpty &&
        serviceAreaController.text.isNotEmpty;
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

  void addKeyword() {
    final keyword = keywordController.text.trim();
    if (keyword.isNotEmpty && !keywords.contains(keyword)) {
      keywords.add(keyword);
      keywordController.clear();
      _validateStep2();
    }
  }

  void removeKeyword(String keyword) {
    keywords.remove(keyword);
    _validateStep2();
  }
  
  void selectCountry(String country) {
    selectedCountry.value = country;
    selectedCity.value = ''; // Reset city when country changes
    _validateStep3();
  }
  
  void selectCity(String city) {
    if (city != 'Select your city') {
      selectedCity.value = city;
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
    serviceTitleController.dispose();
    experienceController.dispose();
    keywordController.dispose();
    serviceAreaController.dispose();
    super.onClose();
  }
}
