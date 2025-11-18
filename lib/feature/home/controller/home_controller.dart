import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  
  // Text data
  final String greetingText = "Hey, Glad You're Here";
  final String userName = "Johnson Mate";
  
  // Categories
  final List<Map<String, String>> categories = [
    {'name': 'Plumber', 'icon': 'assets/icons/plumber.png'},
    {'name': 'Painting', 'icon': 'assets/icons/painting.png'},
    {'name': 'Cleaning', 'icon': 'assets/icons/cleaning.png'},
    {'name': 'Carpenter', 'icon': 'assets/icons/carpainter.png'},
    {'name': 'Photographer', 'icon': 'assets/icons/photographer.png'},
    {'name': 'Electrician', 'icon': 'assets/icons/electrician.png'},
    {'name': 'Installation', 'icon': 'assets/icons/installation.png'},
    {'name': 'Repairing', 'icon': 'assets/icons/repairing.png'},
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