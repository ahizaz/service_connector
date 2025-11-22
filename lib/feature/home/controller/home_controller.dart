import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  
  // Service provider mode
  final RxBool isServiceProvider = false.obs;
  
  // Text data
  final String greetingText = "Hey, Glad You're Here";
  final String userName = "Johnson Mate";
  
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    loadServiceProviderMode();
  }
  
  // Reload mode when screen is revisited
  void reloadMode() {
    loadServiceProviderMode();
  }
  
  Future<void> loadServiceProviderMode() async {
    final prefs = await SharedPreferences.getInstance();
    isServiceProvider.value = prefs.getBool('is_service_provider') ?? false;
  }
  
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

  // Services by category
  final Map<String, List<Map<String, dynamic>>> categoryServices = {
    'Plumber': [
      {
        'name': 'Bathroom Fittings',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 37,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Pipe Installation',
        'professional': 'Johnson Mate - Plumber',
        'rating': 4.8,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Water Heater Installation',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Water Tank Cleaning',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Bathroom Fittings',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Sewer Line Maintenance',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Leak Repair',
        'professional': 'Abdur Rahman - Plumber',
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Electrician': [
      {
        'name': 'Wiring Installation',
        'professional': 'John Smith - Electrician',
        'rating': 4.8,
        'reviews': 42,
        'price': 15,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Light Fixture Setup',
        'professional': 'Mike Johnson - Electrician',
        'rating': 4.7,
        'reviews': 35,
        'price': 12,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Circuit Breaker Repair',
        'professional': 'John Smith - Electrician',
        'rating': 4.9,
        'reviews': 50,
        'price': 18,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Socket Installation',
        'professional': 'Mike Johnson - Electrician',
        'rating': 4.6,
        'reviews': 30,
        'price': 10,
        'image': ImagePath.waterInstallation,
      },
    ],
    'Painting': [
      {
        'name': 'Interior Painting',
        'professional': 'David Brown - Painter',
        'rating': 4.8,
        'reviews': 45,
        'price': 20,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Exterior Painting',
        'professional': 'Robert Wilson - Painter',
        'rating': 4.7,
        'reviews': 38,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Wall Texture',
        'professional': 'David Brown - Painter',
        'rating': 4.9,
        'reviews': 42,
        'price': 22,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Cleaning': [
      {
        'name': 'House Cleaning',
        'professional': 'Sarah Martinez - Cleaner',
        'rating': 4.9,
        'reviews': 60,
        'price': 15,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Deep Cleaning',
        'professional': 'Emma Davis - Cleaner',
        'rating': 4.8,
        'reviews': 55,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Office Cleaning',
        'professional': 'Sarah Martinez - Cleaner',
        'rating': 4.7,
        'reviews': 40,
        'price': 18,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Carpenter': [
      {
        'name': 'Furniture Assembly',
        'professional': 'James Anderson - Carpenter',
        'rating': 4.8,
        'reviews': 48,
        'price': 20,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Cabinet Installation',
        'professional': 'Thomas Taylor - Carpenter',
        'rating': 4.9,
        'reviews': 52,
        'price': 30,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Door Repair',
        'professional': 'James Anderson - Carpenter',
        'rating': 4.7,
        'reviews': 35,
        'price': 15,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Photographer': [
      {
        'name': 'Event Photography',
        'professional': 'Chris Lee - Photographer',
        'rating': 4.9,
        'reviews': 65,
        'price': 50,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Portrait Photography',
        'professional': 'Anna White - Photographer',
        'rating': 4.8,
        'reviews': 58,
        'price': 40,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Product Photography',
        'professional': 'Chris Lee - Photographer',
        'rating': 4.7,
        'reviews': 45,
        'price': 35,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Installation': [
      {
        'name': 'AC Installation',
        'professional': 'Kevin Harris - Technician',
        'rating': 4.8,
        'reviews': 50,
        'price': 40,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'TV Wall Mount',
        'professional': 'Mark Clark - Technician',
        'rating': 4.7,
        'reviews': 42,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Washing Machine Setup',
        'professional': 'Kevin Harris - Technician',
        'rating': 4.9,
        'reviews': 55,
        'price': 20,
        'image': ImagePath.pipeInstallation,
      },
    ],
    'Repairing': [
      {
        'name': 'Computer Repair',
        'professional': 'Abdur Rahman - Technician',
        'rating': 4.5,
        'reviews': 23,
        'price': 23,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Washing Machine Repair',
        'professional': 'Abdur Rahman - Technician',
        'rating': 4.5,
        'reviews': 23,
        'price': 23,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Refrigerator Repair',
        'professional': 'Daniel Moore - Technician',
        'rating': 4.6,
        'reviews': 38,
        'price': 28,
        'image': ImagePath.pipeInstallation,
      },
    ],
  };

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    // Search logic will go here
    debugPrint('Searching for: $value');
  }

  void clearSearch() {
    searchController.clear();
  }
}