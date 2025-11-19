import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  
  // Text data
  final String greetingText = "Hey, Glad You're Here";
  final String userName = "Johnson Mate";
  
  // Categories
  final List<Map<String, String>> categories = [
    {'name': 'Plumber', 'icon': IconPath.plumber},
    {'name': 'Painting', 'icon': IconPath.painting},
    {'name': 'Cleaning', 'icon': IconPath.cleaning},
    {'name': 'Carpenter', 'icon': IconPath.carpenter},
    {'name': 'Photographer', 'icon': IconPath.photographer},
    {'name': 'Electrician', 'icon': IconPath.electrician},
    {'name': 'Installation', 'icon': IconPath.installation},
    {'name': 'Repairing', 'icon': IconPath.repairing},
  ];

  // Top Rated Professionals
  final List<Map<String, dynamic>> topRatedProfessionals = [
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'rating': 4.5,
      'price': 23,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
  ];

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    // Search logic will go here
    print('Searching for: $value');
  }

  void clearSearch() {
    searchController.clear();
  }
}