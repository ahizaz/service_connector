import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/profile/controller/profile_controller.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final ProfileController controller = Get.find<ProfileController>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.userName.value);
    emailController = TextEditingController(text: controller.userEmail.value);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    if (isEditing) {
      // Save changes
      controller.updateUserInfo(
        name: nameController.text,
        email: emailController.text,
      );
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              
              // Profile Picture Section
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final imageFile = controller.profileImage.value;
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffFDDAD1),
                            width: 8.w,
                          ),
                          color: Colors.grey[300],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: imageFile != null
                            ? Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person,
                                size: 60.sp,
                                color: Colors.grey[600],
                              ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Color(0xffFDDAD1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Full Name Field
              _buildTextField(
                label: 'Full Name',
                controller: nameController,
                enabled: isEditing,
              ),
              
              SizedBox(height: 20.h),
              
              // Email Field
              _buildTextField(
                label: 'E-mail',
                controller: emailController,
                enabled: isEditing,
              ),
              
              SizedBox(height: 40.h),
              
              // Edit/Save Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFDDAD1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: !enabled,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  Icons.edit,
                  size: 20.sp,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}