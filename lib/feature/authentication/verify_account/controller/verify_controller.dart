import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/authentication/finish_page/screen/finish_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/feature/authentication/sign_up/controller/signup_controller.dart';

class VerifyController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  
  RxBool isLoading = false.obs;
  RxInt resendTimer = 60.obs;
  RxBool canResend = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void verifyOtp() async {
    if (otpController.text.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Verifying...');

    try {
      final signupController = Get.find<SignUpController>();
      final email = signupController.emailController.text.trim();
      final body = jsonEncode({
        'email': email,
        'otp_code': otpController.text.trim(),
      });

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
      isLoading.value = false;

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.to(() => const FinishPage());
      } else {
        Get.snackbar('Verification failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      debugPrint('Verify error: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  void resendOtp() async {
    if (!canResend.value) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Resending OTP...');

    try {
      final signupController = Get.find<SignUpController>();
      final email = signupController.emailController.text.trim();
      final body = jsonEncode({
        'email': email,
      });

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
      isLoading.value = false;

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'Success',
          'OTP sent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        startResendTimer();
      } else {
        Get.snackbar('Resend failed', res.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      debugPrint('Resend error: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> forgetPassword(String email) async {
    isLoading.value = true;
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
      isLoading.value = false;

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Password reset link sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar('Failed', res.body);
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      debugPrint('ForgetPassword error: $e');
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    otpFocusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }
} 