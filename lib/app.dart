import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:service_connect/core/utils/theme/theme.dart';
import 'package:service_connect/feature/splash_screen/screen/first_splash_screen.dart';
import 'package:service_connect/feature/profile/screen/account.dart';

class ServiceConnector extends StatelessWidget {
  const ServiceConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430,932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title:'Service connect',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: FirstSplashScreen(),
        getPages: [
          GetPage(name: '/account', page: () => const Account()),
        ],

        
      )
    );
  }
}