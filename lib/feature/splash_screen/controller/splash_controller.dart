import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service_connect/feature/splash_screen/screen/second_splash_screen.dart';

class SplashController extends GetxController{
  void onInit(){
    super.onInit();
    Timer(const Duration(seconds: 5),(){
     Get.to(()=>SecondSplashScreen());
    });
  
    
  }
}