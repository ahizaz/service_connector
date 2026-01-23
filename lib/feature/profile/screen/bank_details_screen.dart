import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/core/urls/urls.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankDetailsController = TextEditingController();

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankDetailsController.dispose();
    super.dispose();
  }

  void _saveBankDetails() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Saving...');
      
      try {
        final token = AuthService.getToken();
        if (token == null || token.isEmpty) {
          EasyLoading.dismiss();
          Get.snackbar(
            'Error',
            'Not authenticated',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          return;
        }

        final response = await http.post(
          Uri.parse(Url.providerBankdetails),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'bank_account_name': _accountNameController.text.trim(),
            'bank_account_number': _accountNumberController.text.trim(),
            'bank_details': _bankDetailsController.text.trim(),
          }),
        );

        EasyLoading.dismiss();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          Get.snackbar(
            'Success',
            'Bank details saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          Get.back();
        } else {
          final errorData = json.decode(response.body);
          Get.snackbar(
            'Error',
            errorData['message'] ?? 'Failed to save bank details',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        EasyLoading.dismiss();
        Get.snackbar(
          'Error',
          'Failed to save bank details: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Bank Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                
                // Bank Account Name
                Text(
                  'Bank Account Name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff313131),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter account holder name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter account holder name';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 20.h),
                
                // Bank Account Number
                Text(
                  'Bank Account Number',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff313131),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter account number',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter account number';
                    }
                    if (value.trim().length < 8) {
                      return 'Account number must be at least 8 digits';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 20.h),
                
                // Bank Details
                Text(
                  'Bank Details',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff313131),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _bankDetailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter bank name, branch, routing number, etc.',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter bank details';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 40.h),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveBankDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFE724C),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Bank Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
