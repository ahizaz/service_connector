import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confimPasswordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isSignUpEnabled = false.obs;
  
  // Service provider mode
  var isServiceProvider = false.obs;

  @override
  void onInit() {

    super.onInit();
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
  
  void toggleServiceProviderMode(bool value) {
    isServiceProvider.value = value;
  }
  
  void _validateFields(){
    isSignUpEnabled.value = emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confimPasswordController.text.isNotEmpty;
  }
  
  Future<void> saveServiceProviderMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_service_provider', isServiceProvider.value);
  }
  
  @override
  void onClose(){
    emailController.dispose();
    passwordController.dispose();
    confimPasswordController.dispose();
    super.onClose();
  }
}