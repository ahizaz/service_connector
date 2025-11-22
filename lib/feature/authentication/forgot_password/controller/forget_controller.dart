import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/authentication/forgot_password/screen/forget_verification.dart';

class ForgetController extends GetxController{
  final TextEditingController emailController = TextEditingController();
  RxBool isEmailValid = false.obs;
  
  // Pinput Controller for OTP
  final TextEditingController pinController = TextEditingController();
  
  RxBool isOtpValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    pinController.addListener(_validateOtp);
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    isEmailValid.value = email.isNotEmpty && _isValidEmail(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  void _validateOtp() {
    isOtpValid.value = pinController.text.length == 6;
  }
  
  void onOtpChanged(String value) {
    _validateOtp();
  }
  
  void onOtpCompleted(String pin) {
    _validateOtp();
  }
  
  String getOtpCode() {
    return pinController.text;
  }

  void sendOtp() {
    if (isEmailValid.value) {
    
      debugPrint('Sending OTP to: ${emailController.text}');
      Get.snackbar('Success', 'OTP sent to ${emailController.text}');
      
      // Navigate to verification screen
      Get.to(() => ForgetVerification());
    }
  }
  
  void verifyOtp() {
    if (isOtpValid.value) {
      final otpCode = getOtpCode();
    
      debugPrint('Verifying OTP: $otpCode');
      Get.snackbar('Success', 'OTP verified successfully');
      

    }
  }
  
  void resendOtp() {
 
    debugPrint('Resending OTP to: ${emailController.text}');
    Get.snackbar('Success', 'OTP resent to ${emailController.text}');
    
    // Clear OTP field
    pinController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    pinController.dispose();
    
    super.onClose();
  }
}