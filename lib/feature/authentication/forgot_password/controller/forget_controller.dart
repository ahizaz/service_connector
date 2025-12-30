import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/authentication/forgot_password/screen/forget_verification.dart';
import 'package:service_connect/feature/authentication/verify_account/controller/verify_controller.dart';

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

  void sendOtp() async {
    if (isEmailValid.value) {
      final email = emailController.text.trim();
      debugPrint('Sending OTP to: $email');

      final verifyController = Get.put(VerifyController());
      final success = await verifyController.forgetPassword(email);

      if (success) {
        // clear the email field before navigating to verification
        emailController.clear();
        Get.to(() => ForgetVerification());
      }
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