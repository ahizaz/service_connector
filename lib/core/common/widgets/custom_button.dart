import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double height;
  final double borderRadius;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = const Color(0xffCC0000),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.height = 46,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: textColor,
              fontSize: fontSize.sp,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
