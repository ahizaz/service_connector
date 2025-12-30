import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';
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
  
  void resetPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }
    if (confirmPass.isEmpty) {
      Get.snackbar('Error', 'Please confirm your password');
      return;
    }
    if (newPass != confirmPass) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    EasyLoading.show(status: 'Resetting password...');
    try {
      final body = jsonEncode({'new_password': newPass});
      debugPrint('ResetPassword request body: $body');

      final uri = Uri.parse(Url.resetPassword);
      final headers = {'Content-Type': 'application/json'};
      final token = AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final res = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      debugPrint('ResetPassword response status: ${res.statusCode}');
      debugPrint('ResetPassword response body: ${res.body}');

      EasyLoading.dismiss();

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'Password reset successfully');
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.to(() => const PasswordChange());
      } else {
        Get.snackbar('Failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('ResetPassword error: $e');
      Get.snackbar('Error', e.toString());
    }
  }
  
  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}