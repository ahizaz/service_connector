import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Brooklyn Simmons'.obs;
  final RxString userEmail = 'deanna.curtis@example.com'.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isEditing = false.obs;

  // Keep TextEditingControllers here so they persist across screens.
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: userName.value);
    emailController = TextEditingController(text: userEmail.value);

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