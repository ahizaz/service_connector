import 'package:flutter/material.dart';
import 'package:service_connect/core/utils/constants/colors.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
 return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox.expand(
        child: Image(image: AssetImage(ImagePath.secondsplashscreen,),fit: BoxFit.cover,),
      )
    );
  }
}