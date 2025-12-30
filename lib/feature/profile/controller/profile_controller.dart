import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/feature/authentication/login/screen/login_screen.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/profile/screen/terms_and_conditions_screen.dart';
import 'package:service_connect/feature/profile/screen/about_screen.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Brooklyn Simmons'.obs;
  final RxString userEmail = 'deanna.curtis@example.com'.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
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

    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
      if (nameController.text != savedName) nameController.text = savedName;
    }
    if (savedEmail != null && savedEmail.isNotEmpty) {
      userEmail.value = savedEmail;
      if (emailController.text != savedEmail) emailController.text = savedEmail;
    }
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