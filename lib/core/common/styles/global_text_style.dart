import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {

  static TextStyle robotoRegular({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xff313131),
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
