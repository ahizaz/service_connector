import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/core/common/widgets/custom_password_field.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/authentication/login/controller/signup_controller.dart';
class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 98.h),
            Center(
              child: Image(
                image: AssetImage(ImagePath.logo),
                width: 190.w,
                height: 70.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 64.h),
            Text(
              "Create your Account",
              style: AppTextStyles.robotoRegular(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 48.h),
            Text(
              "Email Address",
              style: AppTextStyles.robotoRegular(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),

       CustomTextfield(hintText: "Enter your email address", controller: controller.emailController,keyboardType: TextInputType.emailAddress,),
       SizedBox(height: 16.h,),
       Text("Password",style: AppTextStyles.robotoRegular(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ), ),
       SizedBox(height: 8.h),
       Obx(() => CustomPasswordField(
         hintText: "Enter your password",
         controller: controller.passwordController,
         obscureText: !controller.isPasswordVisible.value,
         onToggle: controller.togglePasswordVisibility,
       )),
       SizedBox(height: 16.h,),
       Text("Confirm Password",style: AppTextStyles.robotoRegular(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ), ),
       SizedBox(height: 8.h),
       Obx(()=>CustomPasswordField(hintText: "Re-type your password", controller: controller.confimPasswordController, obscureText: !controller.isConfirmPasswordVisible.value, onToggle: controller.toggleConfirmPasswordVisibility)),
       SizedBox(height: 32.h,),
       InkWell(
        onTap: (){
          
        },
         child: Container(
          width: double.infinity,
          height: 46.h,
          decoration: BoxDecoration(
            color: Color(0xffCC0000),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text("SignUp",style: GoogleFonts.roboto( 
              color: Color(0xffFFFFFF),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500
            ),),
          ),
         ),
       )

          ],
        ),
      ),
    );
  }
}