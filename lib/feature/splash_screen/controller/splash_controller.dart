import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/feature/bottom_navbar/screen/bottom_navbar.dart';
import 'package:service_connect/feature/splash_screen/screen/onboadring_screen.dart';
import 'package:service_connect/feature/splash_screen/screen/second_splash_screen.dart';

class SplashController extends GetxController{
  @override
  void onInit(){
    super.onInit();
    // Check saved token and navigate accordingly after a short splash
    Timer(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null && token.isNotEmpty) {
        // restore token for API calls
        AuthService.setToken(token);
        // go to main app
        Get.offAll(() => BottomNavbar());
        return;
      }

      // no token — continue onboarding flow
      Get.to(() => SecondSplashScreen());
      Timer(const Duration(seconds: 2), () {
        Get.to(() => const OnboadringScreen());
      });
    });
  
    
  }
}