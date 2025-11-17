

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/feature/bottom_navbar/controller/bottom_navcontroller.dart';
import 'package:service_connect/feature/chat/screen/chat_screen.dart';
import 'package:service_connect/feature/hire/screen/hire_screen.dart';
import 'package:service_connect/feature/home/screen/home_screen.dart';
import 'package:service_connect/feature/profile/screen/profile_screen.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});
  final BottomNavcontroller controller = Get.put(BottomNavcontroller());

  final List<Widget> screens = [
    HomeScreen(),
    HireScreen(),
    ChatScreen(),
    ProfileScreen(),

  ];

  final List<String> activeIcons = [
  IconPath.homeactive,
  IconPath.hireactive,
  IconPath.chatactive,
  IconPath.profileactive

  ];

  final List<String> inactiveIcons = [
  IconPath.homeinactive,
  IconPath.hireinactive,
  IconPath.chatinactive,
  IconPath.profileinactive
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      backgroundColor: const Color(0xffF5F5F5),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: const NavigationBarThemeData(
            overlayColor: WidgetStatePropertyAll(Color(0xffF5F5F5)),
          ),
          child: NavigationBar(
            indicatorColor: Colors.transparent,
            elevation: 9,
            height: 96.h,
            shadowColor: Colors.black,
            backgroundColor: const Color(0xffF5F5F5),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (int index) {
              controller.changeIndex(index);
            },
     
            destinations: List.generate(4, (index) {
              return NavigationDestination(
                icon: Image.asset(
                  controller.selectedIndex.value == index
                      ? activeIcons[index]
                      : inactiveIcons[index],
                  width: 64.w,
                ),
                label: '', 
              );
            }),
          ),
        ),
      ),
    );
  }
}