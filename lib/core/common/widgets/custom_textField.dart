import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';

class CustomTextfield extends StatelessWidget{
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  const CustomTextfield({    
   super.key,
   required this.hintText,
   this.keyboardType=TextInputType.text,
   this.obscureText =false, required this.controller,
  });
  @override
  Widget build(BuildContext context){
    return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
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
      enabledBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: Color(0xffF5F5F5),
          width: 1
        )
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular( 12.r),
        borderSide: BorderSide(
            color: Color(0xffCC7A7A),
            width: 1,
        )
      )
    ),
    );
  }
}