import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/authentication/verify_account/screen/verify_screen.dart';

class SignUpController extends GetxController{
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confimPasswordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isSignUpEnabled = false.obs;

  @override
  void onInit() {

    super.onInit();
    nameController.addListener(_validateFields);
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confimPasswordController.addListener(_validateFields);
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void toggleConfirmPasswordVisibility(){
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void _validateFields(){
    isSignUpEnabled.value = nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confimPasswordController.text.isNotEmpty;
  }
  
  Future<void> setDefaultServiceReceiverMode() async {
    // All new users start as service receivers
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_service_provider', false);
  }

  Future<void> signUp() async {
    EasyLoading.show(status: 'Signing up...');
    final body = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
      "name": nameController.text.trim()
    };
    try {
      final uri = Uri.parse(Url.signUp);
      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      debugPrint('Signup response status: ${res.statusCode}');
      debugPrint('Signup response body: ${res.body}');
      EasyLoading.dismiss();
      if (res.statusCode == 200 || res.statusCode == 201) {
        await setDefaultServiceReceiverMode();
        Get.to(()=>VerifyScreen());
      } else {
        Get.snackbar('Signup failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Signup error: $e');
      Get.snackbar('Error', e.toString());
    }
  }
  
  @override
  void onClose(){
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confimPasswordController.dispose();
    super.onClose();
  }
}