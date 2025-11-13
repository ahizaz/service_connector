import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';

class CustomPasswordField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggle;
  
  const CustomPasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.robotoRegular(
          fontSize: 14,
          color: Color(0xff878787),
        ),
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 16.w,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Color(0xff878787),
            size: 20.sp,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Color(0xffF5F5F5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xffCC7A7A),
            width: 1,
          ),
        ),
      ),
    );
  }
}
