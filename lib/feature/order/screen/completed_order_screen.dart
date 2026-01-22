import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:service_connect/feature/order/controller/completed_oders_controller.dart';
import 'package:service_connect/feature/order/widget/completed_order_card.dart';

class CompletedOrderScreen extends StatelessWidget {
  const CompletedOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompletedOdersController());
    return Scaffold(
   backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF0066FF),
        title: Text(
          'Completed Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx((){
        if(controller.completedOrders.isEmpty){
          return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.inbox_outlined,
                  size: 80.sp,
                  color: Color(0xFFBDBDBD),
                ),
                SizedBox(height: 16.h,),
                Text('No completed orders',style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF757575),
                ),)
            ],
          ),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(16.w),
          itemCount: controller.completedOrders.length,
          itemBuilder: (context,index){
          final order =controller.completedOrders[index];
          return CompletedOrderCard(order: order);
        });
        
      }),
    );
  }
}