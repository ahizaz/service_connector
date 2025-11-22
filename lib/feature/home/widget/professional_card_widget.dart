import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfessionalCardWidget extends StatelessWidget {
  final String name;
  final String professional;
  final double rating;
  final int experience; // Years of experience
  final int workDone; // Number of work completed
  final String image;
  final String? category;
  final VoidCallback? onBookNow;
  final VoidCallback? onTap;

  const ProfessionalCardWidget({
    super.key,
    required this.name,
    required this.professional,
    required this.rating,
    required this.experience,
    required this.workDone,
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
                  ],
                ),
                SizedBox(height: 8.h),
                // Experience, Work Done, and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Years Experience
                    _buildStatItem(
                      icon: Icons.work_outline,
                      value: '$experience',
                      label: 'Years\nExperience',
                    ),
                    // Work Done
                    _buildStatItem(
                      icon: Icons.assignment_turned_in_outlined,
                      value: '$workDone+',
                      label: 'Work Done',
                    ),
                    // Rating
                    _buildStatItem(
                      icon: Icons.star_outline,
                      value: rating.toString(),
                      label: 'Rating',
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

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: Color(0xffCC0000),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff252525),
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 9.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff666666),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}