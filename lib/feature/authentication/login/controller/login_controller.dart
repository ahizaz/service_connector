import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController{
    final emailController = TextEditingController();
  final passwordController = TextEditingController();
   var isPasswordVisible = false.obs;
    var isloginEnabled = false.obs;
    var rememberMe = false.obs;
    
     @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    _loadSavedCredentials();
  }
  
    void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }
  
  void _validateFields(){
    isloginEnabled.value = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }
  
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    final isRemembered = prefs.getBool('remember_me') ?? false;
    
    if (isRemembered && savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = true;
    }
  }
  
  Future<void> saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe.value) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }
  
  void handleLogin() {
    if (isloginEnabled.value) {
      saveCredentials();
      // Add your login logic here
      Get.snackbar('Login', 'Login successful!');
    }
  }
  
  void handleForgetPassword() {
    // Add navigation to forget password screen or show dialog
    Get.snackbar(
      'Forget Password',
      'Password reset link will be sent to your email',
      snackPosition: SnackPosition.BOTTOM,
    );
    // You can navigate to forget password screen here
    // Get.to(() => ForgetPasswordScreen());
  }
  
    
  @override
  void onClose(){
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

}