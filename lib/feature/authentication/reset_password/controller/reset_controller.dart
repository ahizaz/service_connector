import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/authentication/reset_password/screen/password_change.dart';

class ResetController extends GetxController{
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void resetPassword() {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please confirm your password');
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    // TODO: Implement reset password API call
    Get.snackbar('Success', 'Password reset successfully');
    
    // Navigate to password change page
    Get.to(() => const PasswordChange());
  }
  
  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}