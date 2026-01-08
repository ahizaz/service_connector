import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/core/urls/urls.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'package:service_connect/feature/bottom_navbar/screen/bottom_navbar.dart';

class LoginController extends GetxController{
    final emailController = TextEditingController();
  final passwordController = TextEditingController();
   var isPasswordVisible = false.obs;
    var isloginEnabled = false.obs;
    var rememberMe = false.obs;
    
     @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    _loadSavedCredentials();
  }
  
    void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }
  
  void _validateFields(){
    isloginEnabled.value = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }
  
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    final isRemembered = prefs.getBool('remember_me') ?? false;
    
    if (isRemembered && savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = true;
    }
  }
  
  Future<void> saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe.value) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }
  
  Future<void> handleLogin() async {
    if (isloginEnabled.value) {
      EasyLoading.show(status: 'Logging in...');
      try {
        final email = emailController.text.trim();
        final password = passwordController.text;
        final body = jsonEncode({'email': email, 'password': password});
        debugPrint('Login request body: $body');

        final uri = Uri.parse(Url.login);
        final res = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        debugPrint('Login response status: ${res.statusCode}');
        debugPrint('Login response body: ${res.body}');

        if (res.statusCode == 200 || res.statusCode == 201) {
          final prefs = await SharedPreferences.getInstance();
          final map = jsonDecode(res.body);
          String? token;
          String? userId;
          if (map is Map && map['data'] != null && map['data'] is Map) {
            final data = map['data'] as Map;
            if (data['access'] != null) token = data['access'];
            if (data['refresh'] != null && token == null) token = data['refresh'];
            if (data['user'] != null && data['user'] is Map) {
              final user = data['user'] as Map;
              if (user['id'] != null) userId = user['id'].toString();
              if (user['name'] != null) {
                await prefs.setString('userName', user['name'].toString());
                debugPrint('Saved userName to SharedPreferences');
              }
              if (user['email'] != null) {
                await prefs.setString('userEmail', user['email'].toString());
                debugPrint('Saved userEmail to SharedPreferences');
              }
            }
          }
          if (token != null) {
            await prefs.setString('accessToken', token);
            AuthService.setToken(token);
            debugPrint('Saved access token to SharedPreferences');
          }
          if (userId != null) {
            await prefs.setString('userId', userId);
            debugPrint('Saved userId to SharedPreferences');
          }

          // save credentials if rememberMe
          await saveCredentials();

          // Check if user is a service provider by checking provider API
          await _checkIfUserIsProvider(userId);

          // Clear input fields
          emailController.clear();
          passwordController.clear();

          EasyLoading.dismiss();
          Get.offAll(() => BottomNavbar());
        } else {
          EasyLoading.dismiss();
          Get.snackbar('Login failed', res.body);
        }
      } catch (e) {
        EasyLoading.dismiss();
        debugPrint('Login error: $e');
        Get.snackbar('Error', e.toString());
      }
    }
  }
  
  // Check if logged-in user has a provider profile
  Future<void> _checkIfUserIsProvider(String? userId) async {
    if (userId == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      debugPrint('=================================');
      debugPrint('Checking if user is provider...');
      debugPrint('User ID: $userId');
      debugPrint('=================================');
      
      // Call provider list API to check if this user has provider profile
      final response = await http.get(
        Uri.parse(Url.getAllproviders),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Provider check response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool isProvider = false;
        
        // Check if this user ID exists in providers list
        if (data['results'] != null && data['results'] is List) {
          final providers = data['results'] as List;
          for (var provider in providers) {
            if (provider['user_id'] != null && provider['user_id'].toString() == userId) {
              isProvider = true;
              debugPrint('✅ User is a SERVICE PROVIDER');
              break;
            }
          }
        }
        
        if (!isProvider) {
          debugPrint('❌ User is a SERVICE RECEIVER (Customer)');
        }
        
        await prefs.setBool('is_service_provider', isProvider);
        debugPrint('Saved is_service_provider: $isProvider');
        
      } else {
        debugPrint('Failed to check provider status, defaulting to receiver');
        await prefs.setBool('is_service_provider', false);
      }
      
      debugPrint('=================================');
      
    } catch (e) {
      debugPrint('Error checking provider status: $e');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_service_provider', false);
    }
  }
  
  void handleForgetPassword() {
    // Add navigation to forget password screen or show dialog
    Get.snackbar(
      'Forget Password',
      'Password reset link will be sent to your email',
      snackPosition: SnackPosition.BOTTOM,
    );
    // You can navigate to forget password screen here
    // Get.to(() => ForgetPasswordScreen());
  }
  
    
  @override
  void onClose(){
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

}