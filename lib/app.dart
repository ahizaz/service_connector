import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ServiceConnector extends StatelessWidget {
  const ServiceConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430,932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(()=>GetMaterialApp(
        debugShowCheckedModeBanner: false,
        
      )),
    );
  }
}