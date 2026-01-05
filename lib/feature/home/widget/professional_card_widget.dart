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
  final String? price; // optional price string like '\$23/hour'
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
    this.price,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            SizedBox(
              height: 100.h,
              child: Stack(
                children: [
             ClipRRect(
  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
  child: image.startsWith('http') 
      ? Image.network(
          image,
          width: 164.w,
          height: 100.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // যদি image load না হয় তাহলে placeholder দেখাবে
            return Container(
              width: 164.w,
              height: 100.h,
              color: Color(0xffF5F5F5),
              child: Icon(Icons.person, size: 40.sp, color: Color(0xff999999)),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            // Image load হওয়ার সময় loading indicator দেখাবে
            if (loadingProgress == null) return child;
            return Container(
              width: 164.w,
              height: 100.h,
              color: Color(0xffF5F5F5),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        )
      : Image.asset(
          image,
          width: 164.w,
          height: 100.h,
          fit: BoxFit.cover,
        ),
),
                  if (category != null)
                    Positioned(
                      top: 6.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xffCC0000),
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
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title on top
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff252525),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6.h),

                  // Provider name on left and rating on right
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          professional,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff666666),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xffFFB800),
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1),
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff252525),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Bottom row: price on left and Book Now button on right
                  Row(
                    children: [
                      if (price != null) ...[
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_money, size: 16.sp, color: const Color(0xffCC0000)),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: price!,
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff252525),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/hour',
                                        style: GoogleFonts.roboto(
                                          fontSize: 11.sp,
                                          color: const Color(0xff757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Spacer(),
                      ],
                      SizedBox(
                        height: 34.h,
                        child: ElevatedButton(
                          onPressed: onBookNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffCC0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            elevation: 0,
                          ),
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
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