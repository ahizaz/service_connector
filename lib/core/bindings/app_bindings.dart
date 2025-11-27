import 'package:get/get.dart';

import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/bottom_navbar/controller/bottom_navcontroller.dart';
import 'package:service_connect/feature/profile/controller/profile_controller.dart';
import 'package:service_connect/feature/splash_screen/controller/splash_controller.dart';
import 'package:service_connect/feature/hire/controller/hire_controller.dart';
import 'package:service_connect/feature/chat/controller/chat_controller.dart';
import 'package:service_connect/feature/authentication/login/controller/login_controller.dart';
import 'package:service_connect/feature/authentication/sign_up/controller/signup_controller.dart';
import 'package:service_connect/feature/authentication/verify_account/controller/verify_controller.dart';
import 'package:service_connect/feature/authentication/reset_password/controller/reset_controller.dart';
import 'package:service_connect/feature/authentication/forgot_password/controller/forget_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core / permanent controllers
    Get.put(HomeController(), permanent: true);
    Get.put(BottomNavcontroller(), permanent: true);

    // Lazily created controllers (available when requested, recreated if removed)
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<HireController>(() => HireController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);

    // Authentication related
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<VerifyController>(() => VerifyController(), fenix: true);
    Get.lazyPut<ResetController>(() => ResetController(), fenix: true);
    Get.lazyPut<ForgetController>(() => ForgetController(), fenix: true);
    Get.lazyPut<ProviderRegistrationController>(() => ProviderRegistrationController(), fenix: true);
  }
}
