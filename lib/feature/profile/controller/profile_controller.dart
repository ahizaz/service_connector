import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
  final RxString userName = 'Brooklyn Simmons'.obs;
  final RxString userEmail = 'deanna.curtis@example.com'.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  
  // Update user information
  void updateUserInfo({String? name, String? email}) {
    if (name != null && name.isNotEmpty) userName.value = name;
    if (email != null && email.isNotEmpty) userEmail.value = email;
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
  
  // Profile menu items
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Account',
      'icon': Icons.person_outline,
      'onTap': () => Get.toNamed('/account'),
    },
    {
      'title': 'Pay Account',
      'icon': Icons.account_balance_wallet_outlined,
      'onTap': () => Get.toNamed('/pay-account'),
    },
    {
      'title': 'Saved',
      'icon': Icons.bookmark_border,
      'onTap': () => Get.toNamed('/saved'),
    },
    {
      'title': 'Trams & Condition',
      'icon': Icons.description_outlined,
      'onTap': () => Get.toNamed('/terms'),
    },
    {
      'title': 'About Us',
      'icon': Icons.info_outline,
      'onTap': () => Get.toNamed('/about'),
    },
  ];
}