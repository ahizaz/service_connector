import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:service_connect/feature/profile/controller/profile_controller.dart';

class ServiceProvideToggle extends StatelessWidget {
  final ProfileController  controller;
  const ServiceProvideToggle({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
   padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
   decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: .1),
        blurRadius:4,
        offset: const Offset(0, 2),
      )
    ]

   ),
   child: Row(
    children: [
      _iconBox(Icons.work_outline),
       SizedBox(width: 12.w),
       Expanded(child: Obx((){
        
        final mode = controller.isServiceProvider.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
      mode?'Service Provider Mode' : 'Service Receiver Mode',
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
       ),
          SizedBox(height: 2.h),
           Text(
                    mode ? 'Offer services' : 'Receive services',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
      ],
        );
       }),
       
       ),
       Obx(()=>Switch(value: controller.isServiceProvider.value, onChanged: controller.toggleServiceProviderMode,
       activeColor: const Color(0xffFDDAD1),
          activeTrackColor: const Color(0xffFDDAD1).withValues(alpha: .5),
       
       ))


    ],
   ),
    );
  }
}
  Widget _iconBox(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 24.sp, color: Colors.black),
    );
  }
