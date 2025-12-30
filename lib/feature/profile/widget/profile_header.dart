import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:service_connect/feature/profile/controller/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
   final ProfileController controller;
  const ProfileHeader({super.key,
  required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
     children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Obx((){
            final image = controller.profileImage.value;
            final imageUrl = controller.profileImageUrl.value;
            return Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffFDDAD1),width: 8.w),
                color: Colors.grey[300],
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) {
                        // If network image fails, fallback to local file or icon
                        if (image != null) return Image.file(image, fit: BoxFit.cover);
                        return Icon(Icons.person, size: 60.sp, color: Colors.grey[600]);
                      },
                    )
                  : (image != null
                      ? Image.file(image, fit: BoxFit.cover)
                      : Icon(Icons.person, size: 60.sp, color: Colors.grey[600])),
            );
          }),
          Positioned(bottom: 0,right: 0,child: InkWell(
            onTap:controller.pickImage,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                  color: Color(0xffFDDAD1),
                    shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.black, size: 20),
            ),

          ))
        ],
      ),
       SizedBox(height: 12.h),
       Obx(()=>Text(controller.userName.value,style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),)),
       SizedBox(height: 4.h),
         Obx(() => Text(
              controller.userEmail.value,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            )),
     ],
    );
  }
}