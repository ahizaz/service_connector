import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfessionalCardWidget extends StatelessWidget {
  final String name;
  final String professional;
  final double rating;
  final int price;
  final String image;
  final String? category;
  final VoidCallback? onBookNow;
  final VoidCallback? onTap;

  const ProfessionalCardWidget({
    super.key,
    required this.name,
    required this.professional,
    required this.rating,
    required this.price,
    required this.image,
    this.category,
    this.onBookNow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 164.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Repairing badge, now with fixed height
          SizedBox(
            height: 120.h,  // Adjust this value to match your second picture's proportions
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    height: double.infinity,  // Fill the SizedBox height
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Color(0xffF5F5F5),
                        child: Icon(
                          Icons.image,
                          size: 40.sp,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                if (category != null)
                  Positioned(
                    top: 4.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Color(0xffCC0000),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        category!,
                        style: GoogleFonts.roboto(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 1.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service name
                Text(
                  name,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff252525),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                // Professional name and rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        professional,
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff666666),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      size: 14.sp,
                      color: Color(0xffFFA500),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      rating.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff252525),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Price and Book Now button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$$price',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff252525),
                            ),
                          ),
                          TextSpan(
                            text: '/hour',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onBookNow,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Color(0xffCC0000),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.roboto(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}