import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confimPasswordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isSignUpEnabled = false.obs;

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
  void _validateFields(){
    isSignUpEnabled.value = emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confimPasswordController.text.isNotEmpty;
  }
  
  @override
  void onClose(){
    emailController.dispose();
    passwordController.dispose();
    confimPasswordController.dispose();
    super.onClose();
  }
}