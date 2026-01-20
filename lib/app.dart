import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:service_connect/core/bindings/app_bindings.dart';
import 'package:service_connect/core/utils/theme/theme.dart';
import 'package:service_connect/feature/splash_screen/screen/first_splash_screen.dart';
import 'package:service_connect/feature/profile/screen/account.dart';
import 'package:service_connect/feature/profile/screen/terms_and_conditions_screen.dart';
import 'package:service_connect/feature/profile/screen/about_screen.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step1_professional_profile.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step2_services_offered.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step3_work_location.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step4_documents.dart';
import 'package:service_connect/feature/offer/screen/offer_list_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        initialBinding: AppBindings(),
        title:'Service connect',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: FirstSplashScreen(),
        getPages: [
          GetPage(name: '/account', page: () => const Account()),
          GetPage(name: '/terms', page: () => const TermsAndConditionsScreen()),
          GetPage(name: '/about', page: () => const AboutScreen()),
          GetPage(name: '/provider-registration-step1', page: () => const Step1ProfessionalProfile()),
          GetPage(name: '/provider-registration-step2', page: () => const Step2ServicesOffered()),
          GetPage(name: '/provider-registration-step3', page: () => const Step3WorkLocation()),
          GetPage(name: '/provider-registration-step4', page: () => const Step4Documents()),
          GetPage(name: '/offer-list', page: () => const OfferListScreen()),
        ],
        builder: EasyLoading.init(),
      )
    );
  }
}