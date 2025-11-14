import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/authentication/finish_page/screen/finish_page.dart';

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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implement actual OTP verification logic here
    // Example:
    // final result = await apiService.verifyOtp(otpController.text);
    // if (result.success) {
    //   Get.offAllNamed('/home');
    // } else {
    //   Get.snackbar('Error', result.message);
    // }

    isLoading.value = false;

    // For now, navigate to finish page
    Get.to(() => const FinishPage());
  }

  void resendOtp() async {
    if (!canResend.value) return;

    

    Get.snackbar(
      'Success',
      'OTP sent successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    startResendTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    otpFocusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }
} 