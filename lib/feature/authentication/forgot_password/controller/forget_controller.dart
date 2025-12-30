import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/feature/authentication/forgot_password/screen/forget_verification.dart';
import 'package:service_connect/feature/authentication/reset_password/screen/reset_password.dart';

class ForgetController extends GetxController{
  final TextEditingController emailController = TextEditingController();
  RxBool isEmailValid = false.obs;
  
  // Pinput Controller for OTP
  final TextEditingController pinController = TextEditingController();
  
  RxBool isOtpValid = false.obs;
  String? sentEmail;

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

      // Call forget-password API
      EasyLoading.show(status: 'Sending...');
      try {
        final body = jsonEncode({'email': email});
        debugPrint('ForgetPassword request body: $body');

        final uri = Uri.parse(Url.forgetPassword);
        final res = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        debugPrint('ForgetPassword response status: ${res.statusCode}');
        debugPrint('ForgetPassword response body: ${res.body}');

        EasyLoading.dismiss();

        if (res.statusCode == 200 || res.statusCode == 201) {
          // store the email for later verification/resend
          sentEmail = email;
          // clear the email field before navigating to verification
          emailController.clear();
          Get.snackbar('Success', 'OTP sent to $email');
          Get.to(() => ForgetVerification());
        } else {
          Get.snackbar('Failed', res.body);
        }
      } catch (e) {
        EasyLoading.dismiss();
        debugPrint('ForgetPassword error: $e');
        Get.snackbar('Error', e.toString());
      }
    }
  }
  
  void verifyOtp() async {
    if (!isOtpValid.value) return;
    final otpCode = getOtpCode();
    final email = sentEmail ?? emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not available');
      return;
    }

    EasyLoading.show(status: 'Verifying...');
    try {
      final body = jsonEncode({'email': email, 'otp_code': otpCode});
      debugPrint('Verify request body: $body');

      final uri = Uri.parse(Url.verifyScreen);
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('Verify response status: ${res.statusCode}');
      debugPrint('Verify response body: ${res.body}');

      EasyLoading.dismiss();

      if (res.statusCode == 200 || res.statusCode == 201) {
        // try to extract token from response and store for reset-password
        try {
          final map = jsonDecode(res.body);
          String? token;
          if (map is Map) {
            if (map['token'] != null) token = map['token'];
            if (map['access'] != null) token = map['access'];
            if (map['access_token'] != null) token = map['access_token'];
            if (map['data'] != null && map['data'] is Map) {
              final data = map['data'] as Map;
              if (data['token'] != null) token = data['token'];
              if (data['access'] != null) token = data['access'];
              if (data['access_token'] != null) token = data['access_token'];
            }
          }
          if (token != null) {
            AuthService.setToken(token);
            debugPrint('Saved bearer token from forget verify');
          } else {
            debugPrint('No token found in forget verify response');
          }
        } catch (e) {
          debugPrint('Token parse error: $e');
        }

        Get.snackbar('Success', 'OTP verified successfully');
        // clear OTP field
        pinController.clear();
        Get.to(() => ResetPassword());
      } else {
        Get.snackbar('Verification failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Verify error: $e');
      Get.snackbar('Error', e.toString());
    }
  }
  
  void resendOtp() async {
    final email = sentEmail ?? emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not available');
      return;
    }

    EasyLoading.show(status: 'Resending OTP...');
    try {
      final body = jsonEncode({'email': email});
      debugPrint('Resend request body: $body');

      final uri = Uri.parse(Url.resendOtp);
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('Resend response status: ${res.statusCode}');
      debugPrint('Resend response body: ${res.body}');

      EasyLoading.dismiss();

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'OTP resent to $email');
        // Clear OTP field
        pinController.clear();
      } else {
        Get.snackbar('Failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Resend error: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    pinController.dispose();
    
    super.onClose();
  }
}