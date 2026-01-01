import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step4_documents.dart';

class ProviderRegistrationController extends GetxController {
  // Step 1: Professional Profile Setup
  late TextEditingController bioController;
  // Optional fields: language and license number
  late TextEditingController providerLanguageController;
  late TextEditingController licenseNumberController;
  // Required: provider service charge
  late TextEditingController serviceChargeController;
  // portfolio images removed from step1

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
  late TextEditingController cityController;
  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;

  // Step 4: Documents
  final Rx<File?> tradeLicenseDoc = Rx<File?>(null);
  final Rx<File?> insuranceDoc = Rx<File?>(null);
  // Step 5: Work Images (portfolio)
  final RxList<File> portfolioImages = <File>[].obs;

  // Store provider ID from creation response
  final RxInt providerId = 0.obs;

  final ImagePicker _picker = ImagePicker();

  // Validation states
  final RxBool isStep1Valid = false.obs;
  final RxBool isStep2Valid = false.obs;
  final RxBool isStep3Valid = false.obs;
  final RxBool isStep4Valid = false.obs;
  final RxBool isStep5Valid = false.obs;

  final RxInt currentStep = 0.obs;

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

  // Use central `Url` definitions for API endpoints
  final String createServiceProvider = Url.createServiceProvider;

  // Full list of countries (195). Values are country names only; emojis removed for brevity.
  final List<String> countriesList = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville)',
    'Costa Rica',
    'Côte d’Ivoire',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czechia',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  final Map<String, List<String>> citiesByCountry = {
    'United States': [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'Philadelphia',
      'San Antonio',
      'San Diego',
      'Dallas',
      'Miami',
    ],
    'United Kingdom': [
      'London',
      'Manchester',
      'Birmingham',
      'Liverpool',
      'Leeds',
      'Glasgow',
      'Edinburgh',
      'Bristol',
      'Cardiff',
      'Belfast',
    ],
    'Canada': [
      'Toronto',
      'Vancouver',
      'Montreal',
      'Calgary',
      'Ottawa',
      'Edmonton',
      'Winnipeg',
      'Quebec City',
      'Hamilton',
      'Victoria',
    ],
    'Australia': [
      'Sydney',
      'Melbourne',
      'Brisbane',
      'Perth',
      'Adelaide',
      'Gold Coast',
      'Canberra',
      'Newcastle',
      'Hobart',
      'Darwin',
    ],
    'Germany': [
      'Berlin',
      'Munich',
      'Hamburg',
      'Frankfurt',
      'Cologne',
      'Stuttgart',
      'Düsseldorf',
      'Dortmund',
      'Leipzig',
      'Dresden',
    ],
    'France': [
      'Paris',
      'Marseille',
      'Lyon',
      'Toulouse',
      'Nice',
      'Nantes',
      'Strasbourg',
      'Montpellier',
      'Bordeaux',
      'Lille',
    ],
    'India': [
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Hyderabad',
      'Chennai',
      'Kolkata',
      'Pune',
      'Ahmedabad',
      'Jaipur',
      'Surat',
    ],
    'Japan': [
      'Tokyo',
      'Osaka',
      'Yokohama',
      'Nagoya',
      'Sapporo',
      'Fukuoka',
      'Kobe',
      'Kyoto',
      'Hiroshima',
      'Sendai',
    ],
    'China': [
      'Beijing',
      'Shanghai',
      'Guangzhou',
      'Shenzhen',
      'Chengdu',
      'Hangzhou',
      'Wuhan',
      'Xian',
      'Chongqing',
      'Tianjin',
    ],
    'Brazil': [
      'São Paulo',
      'Rio de Janeiro',
      'Brasília',
      'Salvador',
      'Fortaleza',
      'Belo Horizonte',
      'Manaus',
      'Curitiba',
      'Recife',
      'Porto Alegre',
    ],
    'Mexico': [
      'Mexico City',
      'Guadalajara',
      'Monterrey',
      'Puebla',
      'Tijuana',
      'León',
      'Juárez',
      'Zapopan',
      'Mérida',
      'Cancún',
    ],
    'Spain': [
      'Madrid',
      'Barcelona',
      'Valencia',
      'Seville',
      'Zaragoza',
      'Málaga',
      'Murcia',
      'Palma',
      'Bilbao',
      'Alicante',
    ],
    'Italy': [
      'Rome',
      'Milan',
      'Naples',
      'Turin',
      'Palermo',
      'Genoa',
      'Bologna',
      'Florence',
      'Venice',
      'Verona',
    ],
    'Netherlands': [
      'Amsterdam',
      'Rotterdam',
      'The Hague',
      'Utrecht',
      'Eindhoven',
      'Tilburg',
      'Groningen',
      'Almere',
      'Breda',
      'Nijmegen',
    ],
    'Singapore': [
      'Singapore City',
      'Jurong',
      'Woodlands',
      'Tampines',
      'Bedok',
      'Sengkang',
      'Hougang',
      'Punggol',
      'Yishun',
      'Bukit Batok',
    ],
    'UAE': [
      'Dubai',
      'Abu Dhabi',
      'Sharjah',
      'Ajman',
      'Ras Al Khaimah',
      'Fujairah',
      'Umm Al Quwain',
      'Al Ain',
      'Khor Fakkan',
      'Dibba',
    ],
    'Saudi Arabia': [
      'Riyadh',
      'Jeddah',
      'Mecca',
      'Medina',
      'Dammam',
      'Khobar',
      'Tabuk',
      'Buraidah',
      'Khamis Mushait',
      'Abha',
    ],
    'South Korea': [
      'Seoul',
      'Busan',
      'Incheon',
      'Daegu',
      'Daejeon',
      'Gwangju',
      'Suwon',
      'Ulsan',
      'Changwon',
      'Goyang',
    ],
    'Bangladesh': [
      'Dhaka',
      'Chittagong',
      'Khulna',
      'Rajshahi',
      'Sylhet',
      'Barisal',
      'Rangpur',
      'Comilla',
      'Gazipur',
      'Narayanganj',
    ],
    'Pakistan': [
      'Karachi',
      'Lahore',
      'Islamabad',
      'Rawalpindi',
      'Faisalabad',
      'Multan',
      'Peshawar',
      'Quetta',
      'Sialkot',
      'Gujranwala',
    ],
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
    bioController = TextEditingController();
    providerLanguageController = TextEditingController();
    licenseNumberController = TextEditingController();
    serviceChargeController = TextEditingController();
    serviceCategoryController = TextEditingController();
    serviceTitleController = TextEditingController();
    experienceController = TextEditingController();
    keywordController = TextEditingController();
    serviceAreaController = TextEditingController();
    cityController = TextEditingController();

    // Add listeners
    bioController.addListener(_validateStep1);
    serviceChargeController.addListener(_validateStep1);
    // providerLanguageController and licenseNumberController are optional and do not affect validation

    serviceTitleController.addListener(_validateStep2);
    experienceController.addListener(_validateStep2);

    serviceAreaController.addListener(_validateStep3);
    cityController.addListener(() {
      selectCity(cityController.text);
    });
  }

  void _validateStep1() {
    // Profile description is optional now; require a valid service charge to proceed
    final chargeText = serviceChargeController.text.trim();
    if (chargeText.isEmpty) {
      isStep1Valid.value = false;
      return;
    }
    final value = double.tryParse(chargeText.replaceAll(',', '.'));
    isStep1Valid.value = value != null && value > 0;
  }

  void _validateStep2() {
    isStep2Valid.value =
        selectedCategories.isNotEmpty &&
        serviceTitleController.text.isNotEmpty &&
        experienceController.text.isNotEmpty &&
        keywords.isNotEmpty;
  }

  void _validateStep3() {
    isStep3Valid.value =
        selectedCountry.value.isNotEmpty &&
        selectedCity.value.isNotEmpty &&
        serviceAreaController.text.isNotEmpty;
  }

  void _validateStep4() {
    // Only passport (tradeLicenseDoc) is required to enable Submit.
    // Insurance/uploaded additional docs are optional in this flow.
    isStep4Valid.value = tradeLicenseDoc.value != null;
  }

  // Image picking methods
  // Profile image has been removed from registration flow.

  Future<void> pickPortfolioImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (images != null && images.isNotEmpty) {
        for (final img in images) {
          portfolioImages.add(File(img.path));
        }
        _validateStep5();
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
    if (index >= 0 && index < portfolioImages.length) {
      portfolioImages.removeAt(index);
      _validateStep5();
    }
  }

  void _validateStep5() {
    isStep5Valid.value = portfolioImages.isNotEmpty;
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
      // Enforce single selection: if the category is already selected, deselect it;
      // otherwise clear previous selections and keep only the new one.
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
        selectedCategory.value = '';
      } else {
        selectedCategories.clear();
        selectedCategories.add(category);
        selectedCategory.value = category;
      }
      _validateStep2();
    }
  }

  void removeCategory(String category) {
    selectedCategories.remove(category);
    if (selectedCategory.value == category) selectedCategory.value = '';
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
    if (cityController.text.isNotEmpty) cityController.clear();
    _validateStep3();
  }

  void selectCity(String city) {
    // For typed city input, accept any non-empty string
    if (city.trim().isNotEmpty && city != 'Select your city') {
      selectedCity.value = city.trim();
      _validateStep3();
    } else if (city.trim().isEmpty) {
      selectedCity.value = '';
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

  Future<void> completeRegistration({bool navigateToDocuments = false}) async {
    // Attempt to read user id and token from SharedPreferences (fallback)
    final prefs = await SharedPreferences.getInstance();
    // Try multiple possible keys for user id and token
    String? userId =
        prefs.getString('userId') ??
        prefs.getString('user_id') ??
        prefs.getString('id');
    String? token =
        AuthService.getToken() ??
        prefs.getString('accessToken') ??
        prefs.getString('auth_token') ??
        prefs.getString('token') ??
        prefs.getString('access_token');

    debugPrint(
      'completeRegistration: resolved userId=${userId ?? 'null'} tokenPresent=${token != null}',
    );

    if (userId == null || userId.isEmpty) {
      _showError('User ID not found. Please login again.');
      debugPrint(
        'completeRegistration aborted: missing user id (checked keys: userId,user_id,id)',
      );
      return;
    }
    if (token == null || token.isEmpty) {
      _showError('Authorization token not found. Please login again.');
      debugPrint(
        'completeRegistration aborted: missing token (checked AuthService and prefs keys)',
      );
      return;
    }

    // Build request body
    final int categoryId = _mapCategoryToId();

    final body = _buildRequestBody(userId, categoryId);

    try {
      EasyLoading.show(status: 'Creating provider...');

      debugPrint('POST $createServiceProvider');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      debugPrint('Request headers: $headers');
      debugPrint('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(createServiceProvider),
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response to extract provider ID
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (responseData.containsKey('id')) {
            providerId.value = responseData['id'];
            await prefs.setInt('provider_id', providerId.value);
            debugPrint('Provider created with ID: ${providerId.value}');
          }
        } catch (e) {
          debugPrint('Failed to parse provider ID from response: $e');
        }

        await prefs.setBool('provider_registration_completed', true);
        // If caller wants to navigate to documents (Step 4) immediately,
        // reset fields and push the Step4 screen.
        if (navigateToDocuments) {
          _resetFormFields();
          try {
            Get.to(() => const Step4Documents());
          } catch (_) {}
        } else {
          _resetFormFields();
        }
        Get.snackbar(
          'Success',
          'Registration completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String message = 'Failed to create provider. (${response.statusCode})';
        try {
          final Map<String, dynamic> resp = jsonDecode(response.body);
          if (resp.containsKey('detail')) message = resp['detail'].toString();
          if (resp.containsKey('message')) message = resp['message'].toString();
        } catch (_) {}
        _showError(message);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _showError('Network error: $e');
      debugPrint('Network error: $e');
    }
  }

  int _mapCategoryToId() {
    String cat = selectedCategory.value;
    if (cat.isEmpty && selectedCategories.isNotEmpty) {
      cat = selectedCategories.first;
    }
    final idx = serviceCategories.indexOf(cat);
    if (idx >= 0) return idx + 1; // 1-based ids as requested
    return 0;
  }

  Map<String, dynamic> _buildRequestBody(String userId, int categoryId) {
    final title = serviceTitleController.text.trim();
    final description = bioController.text.trim();
    final experience = int.tryParse(experienceController.text.trim()) ?? 0;
    final charge =
        double.tryParse(
          serviceChargeController.text.trim().replaceAll(',', '.'),
        ) ??
        0;
    final lang = providerLanguageController.text.trim();
    final licenceRaw = licenseNumberController.text.trim();
    dynamic licence;
    if (licenceRaw.isNotEmpty) {
      final tryInt = int.tryParse(licenceRaw);
      licence = tryInt ?? licenceRaw;
    }

    final country = selectedCountry.value.isNotEmpty
        ? selectedCountry.value
        : serviceAreaController.text.trim();
    final city = selectedCity.value.isNotEmpty
        ? selectedCity.value
        : cityController.text.trim();

    final Map<String, dynamic> body = {
      'user': userId,
      'service_title': title,
      'service_category': categoryId,
      'provider_description': description,
      'provider_experience': experience,
      'provider_service_charge': charge,
      'provider_service_area': serviceAreaController.text.trim(),
      'provider_city': city,
      'provider_country': country,
      'keywords': keywords.toList(),
    };

    if (lang.isNotEmpty) body['provider_language'] = lang;
    if (licence != null) body['provider_licence_number'] = licence;

    return body;
  }

  void _resetFormFields() {
    bioController.clear();
    providerLanguageController.clear();
    licenseNumberController.clear();
    serviceChargeController.clear();
    serviceCategoryController.clear();
    serviceTitleController.clear();
    experienceController.clear();
    keywordController.clear();
    serviceAreaController.clear();
    cityController.clear();

    selectedCategories.clear();
    selectedCategory.value = '';
    keywords.clear();

    selectedCountry.value = '';
    selectedCity.value = '';

    tradeLicenseDoc.value = null;
    insuranceDoc.value = null;

    isStep1Valid.value = false;
    isStep2Valid.value = false;
    isStep3Valid.value = false;
    isStep4Valid.value = false;

    // Reset to first step after clearing; navigation handled by UI.
    currentStep.value = 0;
    portfolioImages.clear();
    isStep5Valid.value = false;
  }

  @override
  void onClose() {
    bioController.dispose();
    providerLanguageController.dispose();
    licenseNumberController.dispose();
    serviceChargeController.dispose();
    serviceCategoryController.dispose();
    serviceTitleController.dispose();
    experienceController.dispose();
    keywordController.dispose();
    serviceAreaController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // Allow dynamic additions to countries/cities from a form
  void addCountry(String country) {
    if (country.isEmpty) return;
    if (!countriesList.contains(country)) {
      countriesList.add(country);
    }
    citiesByCountry[country] = citiesByCountry[country] ?? <String>[];
  }

  void addCityToCountry(String country, String city) {
    if (country.isEmpty || city.isEmpty) return;
    final list = citiesByCountry[country] ?? <String>[];
    if (!list.contains(city)) {
      list.add(city);
      citiesByCountry[country] = list;
    }
  }

  // Submit documents using the provider ID from creation response
  Future<void> submitDocuments() async {
    // Check if we have a provider ID
    if (providerId.value == 0) {
      // Try to get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getInt('provider_id');
      if (savedId != null) {
        providerId.value = savedId;
      } else {
        _showError(
          'Provider ID not found. Please complete registration first.',
        );
        return;
      }
    }

    // Get authorization token
    final prefs = await SharedPreferences.getInstance();
    String? token =
        AuthService.getToken() ??
        prefs.getString('accessToken') ??
        prefs.getString('auth_token') ??
        prefs.getString('token') ??
        prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      _showError('Authorization token not found. Please login again.');
      return;
    }

    // Build the dynamic submit document URL using Url class
    final submitUrl = Url.submitDocument(providerId.value);
    debugPrint('Submit document URL: $submitUrl');

    try {
      EasyLoading.show(status: 'Submitting documents...');

      var request = http.MultipartRequest('POST', Uri.parse(submitUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Add document_type and document_front (required fields)
      if (tradeLicenseDoc.value != null) {
        // Add document type as form field
        request.fields['document_type'] = 'passport';

        // Add document front (the passport image/document)
        final file = await http.MultipartFile.fromPath(
          'document_front',
          tradeLicenseDoc.value!.path,
        );
        request.files.add(file);
        debugPrint('Added passport document with type: passport');
      }

      // Add insurance document if available (optional)
      if (insuranceDoc.value != null) {
        final file = await http.MultipartFile.fromPath(
          'insurance',
          insuranceDoc.value!.path,
        );
        request.files.add(file);
        debugPrint('Added insurance document');
      }

      // Add portfolio images if available (optional)
      for (int i = 0; i < portfolioImages.length; i++) {
        final file = await http.MultipartFile.fromPath(
          'portfolio_image_$i',
          portfolioImages[i].path,
        );
        request.files.add(file);
      }
      debugPrint('Added ${portfolioImages.length} portfolio images');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Submit document response status: ${response.statusCode}');
      debugPrint('Submit document response body: $responseBody');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Documents submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String message = 'Failed to submit documents. (${response.statusCode})';
        try {
          final Map<String, dynamic> resp = jsonDecode(responseBody);
          if (resp.containsKey('detail')) message = resp['detail'].toString();
          if (resp.containsKey('message')) message = resp['message'].toString();
        } catch (_) {}
        _showError(message);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _showError('Network error: $e');
      debugPrint('Submit documents error: $e');
    }
  }
}
