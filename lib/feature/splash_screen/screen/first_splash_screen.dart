import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:service_connect/core/utils/constants/colors.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/splash_screen/controller/splash_controller.dart';

class FirstSplashScreen extends StatelessWidget {
  const FirstSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox.expand(
        child: Image(image: AssetImage(ImagePath.firstsplashscreen,),fit: BoxFit.cover,),
      )
    );
  }
}