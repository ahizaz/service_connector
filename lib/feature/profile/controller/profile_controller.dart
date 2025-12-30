import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:service_connect/feature/authentication/login/screen/login_screen.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/profile/screen/terms_and_conditions_screen.dart';
import 'package:service_connect/feature/profile/screen/about_screen.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Brooklyn Simmons'.obs;
  final RxString userEmail = 'deanna.curtis@example.com'.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final RxString profileImagePath = ''.obs;
  final RxBool isEditing = false.obs;
  
  // Service Provider Mode Toggle
  final RxBool isServiceProvider = false.obs;

  // Keep TextEditingControllers here so they persist across screens.
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  final ImagePicker _picker = ImagePicker();

  Future<void> _loadServiceProviderMode() async {
    final prefs = await SharedPreferences.getInstance();
    isServiceProvider.value = prefs.getBool('is_service_provider') ?? false;
  }

  Future<void> logout() async {
    EasyLoading.show(status: 'Logging out...');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('userId');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);

      AuthService.setToken(null);
      debugPrint('User logged out and tokens cleared');

      EasyLoading.dismiss();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Logout error: $e');
      Get.snackbar('Error', 'Failed to logout');
    }
  }

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: userName.value);
    emailController = TextEditingController(text: userEmail.value);
    _loadServiceProviderMode();
    _loadProfileFromPrefs();

    // Keep controllers in sync when values change elsewhere.
    ever<String>(userName, (val) {
      if (nameController.text != val) nameController.text = val;
    });
    ever<String>(userEmail, (val) {
      if (emailController.text != val) emailController.text = val;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Toggle edit mode; if saving (editing -> false) update Rx values.
  void toggleEditing() {
    if (isEditing.value) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();

      if (name.isNotEmpty) userName.value = name;
      if (email.isNotEmpty) userEmail.value = email;

      // Persist to SharedPreferences
      SharedPreferences.getInstance().then((prefs) {
        if (name.isNotEmpty) prefs.setString('userName', name);
        if (email.isNotEmpty) prefs.setString('userEmail', email);
      });

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
    isEditing.value = !isEditing.value;
  }

  Future<void> _loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('userName');
    final savedEmail = prefs.getString('userEmail');
    final savedImageUrl = prefs.getString('profileImageUrl');
    final savedImagePath = prefs.getString('profileImagePath');

    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
      if (nameController.text != savedName) nameController.text = savedName;
    }
    if (savedEmail != null && savedEmail.isNotEmpty) {
      userEmail.value = savedEmail;
      if (emailController.text != savedEmail) emailController.text = savedEmail;
    }

    if (savedImageUrl != null && savedImageUrl.isNotEmpty) {
      profileImageUrl.value = savedImageUrl;
      debugPrint('Loaded saved profile image URL: $savedImageUrl');
    }

    if (savedImagePath != null && savedImagePath.isNotEmpty) {
      profileImagePath.value = savedImagePath;
      try {
        final f = File(savedImagePath);
        if (await f.exists()) {
          profileImage.value = f;
          debugPrint('Loaded saved profile image file: $savedImagePath');
        } else {
          debugPrint('Saved profile image path does not exist: $savedImagePath');
        }
      } catch (e) {
        debugPrint('Error loading saved profile image file: $e');
      }
    }
  }

  // Try to find an image URL in the response map recursively.
  String? _extractImageUrlFromResponse(Map<String, dynamic> map) {
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is String) {
        final s = value.trim();
        // full URL
        if (s.startsWith('http')) return s;
        // absolute path from server, e.g. /media/..., build full url
        if (s.startsWith('/')) return Url.baseUrl + s;
        // plain filename or path containing common image extension
        final lower = s.toLowerCase();
        if (lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.webp') || lower.contains('media')) {
          // try to return as absolute url if it looks like a server path
          if (s.startsWith('http')) return s;
          if (s.startsWith('/')) return Url.baseUrl + s;
          return Url.baseUrl + '/' + s;
        }
      } else if (value is Map<String, dynamic>) {
        final found = _extractImageUrlFromResponse(value);
        if (found != null) return found;
      } else if (value is List) {
        for (final item in value) {
          if (item is String && item.startsWith('http')) return item;
          if (item is Map<String, dynamic>) {
            final found = _extractImageUrlFromResponse(item);
            if (found != null) return found;
          }
        }
      }
    }
    return null;
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        // After picking an image, upload it to the server
        await uploadProfileImage(profileImage.value!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload profile image via PATCH multipart/form-data
  Future<void> uploadProfileImage(File imageFile) async {
    EasyLoading.show(status: 'Uploading profile image...');
    try {
      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        debugPrint('No auth token available for profile upload');
        Get.snackbar('Error', 'Not authenticated');
        return;
      }

      final uri = Uri.parse(Url.updateProfile);

      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      debugPrint('Sending profile image upload request to: ${uri.toString()}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Profile upload status: ${response.statusCode}');
      debugPrint('Profile upload response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse response and try to extract image URL to persist
        try {
          final data = json.decode(response.body);
          debugPrint('Upload response decoded: $data');

          String? imageUrl;
          if (data is Map<String, dynamic>) {
            imageUrl = _extractImageUrlFromResponse(data);
          }

          if (imageUrl != null && imageUrl.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('profileImageUrl', imageUrl);
            profileImageUrl.value = imageUrl;
            debugPrint('Saved profile image URL: $imageUrl');
          } else {
            // If server did not return a usable URL, persist the local file path as a fallback
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('profileImagePath', imageFile.path);
              profileImagePath.value = imageFile.path;
              debugPrint('Saved local profile image path: ${imageFile.path}');
            } catch (e) {
              debugPrint('Failed to save local image path: $e');
            }
          }
        } catch (e) {
          debugPrint('Failed to parse upload response: $e');
        }

        EasyLoading.dismiss();
        Get.snackbar('Success', 'Profile image updated', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        EasyLoading.dismiss();
        debugPrint('Upload failed with status ${response.statusCode}');
        Get.snackbar('Error', 'Failed to upload image');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload image: $e');
    }
  }

  // Toggle service provider mode
  void toggleServiceProviderMode(bool value) async {
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_service_provider', value);
    
    // If switching to service provider mode, check if registration is completed
    if (value) {
      final hasCompletedRegistration = prefs.getBool('provider_registration_completed') ?? false;
      
      if (!hasCompletedRegistration) {
        // Navigate to provider registration flow
        isServiceProvider.value = value;
        Get.toNamed('/provider-registration-step1');
        return;
      }
    }
    
    // Update the mode
    isServiceProvider.value = value;
    
    // Sync with HomeController if it exists
    try {
      final homeController = Get.find<HomeController>();
      homeController.loadServiceProviderMode();
    } catch (e) {
      // HomeController not initialized yet, that's okay
    }
    
    Get.snackbar(
      'Mode Changed',
      value 
          ? 'You are now in Service Provider mode' 
          : 'You are now in Service Receiver mode',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xffFDDAD1),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
      icon: Icon(
        value ? Icons.work_outline : Icons.person_outline,
        color: Colors.black,
      ),
    );
  }

  // Profile menu items
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Account',
      'icon': Icons.person_outline,
      'onTap': () => Get.toNamed('/account'),
    },
    {
      'title': 'Connect with stripe',
      'icon': Icons.account_balance_wallet_outlined,
      'onTap': () => Get.toNamed('/pay-account'),
    },
    // (Removed 'Saved' menu item)
    {
      'title': 'Terms & Conditions',
      'icon': Icons.description_outlined,
      'onTap': () => Get.to(() => const TermsAndConditionsScreen()),
    },
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'onTap': () => Get.to(() => const AboutScreen()),
    },
  ];
}