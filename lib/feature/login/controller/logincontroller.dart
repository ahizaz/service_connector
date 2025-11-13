import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Logincontroller extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confimPasswordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void toggleConfirmPasswordVisibility(){
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  @override
  void onClose(){
    emailController.dispose();
    passwordController.dispose();
    confimPasswordController.dispose();
    super.onClose();
  }
}