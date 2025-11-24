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

  // Dashboard stats (for service providers)
  final RxDouble availableWithdraw = 0.0.obs;
  final RxDouble earningInMonth = 0.0.obs;
  final RxInt activeHire = 0.obs;
  final RxInt cancelHire = 0.obs;
  
  // Text data
  final String greetingText = "Hey, Glad You're Here";
  final String userName = "Johnson Mate";
  
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    loadServiceProviderMode();
    loadDashboardData();
  }
  
  // Reload mode when screen is revisited
  void reloadMode() {
    loadServiceProviderMode();
    // also refresh dashboard data when returning to screen
    loadDashboardData();
  }

  /// Load provider dashboard data.
  /// Currently this sets static/sample values. Replace with API call as needed.
  Future<void> loadDashboardData() async {
    try {
      // TODO: Replace with real data fetch
      availableWithdraw.value = 250.0;
      earningInMonth.value = 380.0;
      activeHire.value = 2;
      cancelHire.value = 5;
    } catch (e) {
      debugPrint('Failed to load dashboard data: $e');
    }
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

  // Professionals Details Data
  final List<Map<String, dynamic>> professionals = [
    {
      'id': 1,
      'name': 'Ramesh Kumar',
      'profession': 'Plumber',
      'experience': '7 years',
      'workDone': '360+',
      'rating': 4.0,
      'reviews': 52,
      'image': 'assets/images/userpicreparing.png',
      'location': 'ID: EL2024303',
      'overview': 'Consequat velit qui adipisicing sunt do reprehenderit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex dolore esse. Consequat velit qui adipisicing et voluptate duis sit esse aliqua esse ex dolore esse.',
      'services': [
        'Pipe Installation',
        'Leak Repair',
        'Water Heater Installation',
        'Bathroom Fittings'
      ],
      'workingDays': 'Monday - Saturday',
      'language': 'English, Hindi',
      'internetTechnician': false,
    },
    {
      'id': 2,
      'name': 'Abdur Rahman',
      'profession': 'Technician',
      'experience': '5 years',
      'workDone': '280+',
      'rating': 4.5,
      'reviews': 23,
      'image': 'assets/images/userpicreparing.png',
      'location': 'ID: EL2024304',
      'overview': 'Expert in computer repair and washing machine services. Highly skilled technician with years of experience in electronics and appliance repair.',
      'services': [
        'Computer Repair',
        'Washing Machine Repair',
        'Laptop Servicing',
        'Hardware Installation'
      ],
      'workingDays': 'Monday - Friday',
      'language': 'English, Urdu',
      'internetTechnician': true,
    },
    {
      'id': 3,
      'name': 'Johnson Mate',
      'profession': 'Plumber',
      'experience': '10 years',
      'workDone': '500+',
      'rating': 4.8,
      'reviews': 47,
      'image': 'assets/images/userpicreparing.png',
      'location': 'ID: EL2024305',
      'overview': 'Professional plumber with extensive experience in residential and commercial plumbing. Specialized in pipe installation and water systems.',
      'services': [
        'Pipe Installation',
        'Sewer Line Maintenance',
        'Water Tank Cleaning',
        'Emergency Repairs'
      ],
      'workingDays': 'All Days',
      'language': 'English',
      'internetTechnician': false,
    },
  ];

  // Top Rated Professionals
  final List<Map<String, dynamic>> topRatedProfessionals = [
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing'
    },
    {
      'name': 'Pipe Installation',
      'professional': 'Ramesh Kumar',
      'professionalId': 1,
      'rating': 4.8,
      'experience': 4,
      'workDone': 360,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Plumber'
    },
    {
      'name': 'Bathroom Fittings',
      'professional': 'Johnson Mate',
      'professionalId': 3,
      'rating': 4.8,
      'experience': 6,
      'workDone': 450,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Plumber'
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
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
        'professionalId': 1,
        'rating': 4.9,
        'reviews': 37,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Pipe Installation',
        'professional': 'Johnson Mate - Plumber',
        'professionalId': 3,
        'rating': 4.8,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Water Heater Installation',
        'professional': 'Ramesh Kumar - Plumber',
        'professionalId': 1,
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Water Tank Cleaning',
        'professional': 'Johnson Mate - Plumber',
        'professionalId': 3,
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Bathroom Fittings',
        'professional': 'Ramesh Kumar - Plumber',
        'professionalId': 1,
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Sewer Line Maintenance',
        'professional': 'Johnson Mate - Plumber',
        'professionalId': 3,
        'rating': 4.9,
        'reviews': 47,
        'price': 13,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Leak Repair',
        'professional': 'Ramesh Kumar - Plumber',
        'professionalId': 1,
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
        'professionalId': 1,
        'rating': 4.8,
        'reviews': 42,
        'price': 15,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Light Fixture Setup',
        'professional': 'Mike Johnson - Electrician',
        'professionalId': 2,
        'rating': 4.7,
        'reviews': 35,
        'price': 12,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Circuit Breaker Repair',
        'professional': 'John Smith - Electrician',
        'professionalId': 1,
        'rating': 4.9,
        'reviews': 50,
        'price': 18,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Socket Installation',
        'professional': 'Mike Johnson - Electrician',
        'professionalId': 2,
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
        'professionalId': 1,
        'rating': 4.8,
        'reviews': 45,
        'price': 20,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Exterior Painting',
        'professional': 'Robert Wilson - Painter',
        'professionalId': 3,
        'rating': 4.7,
        'reviews': 38,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Wall Texture',
        'professional': 'David Brown - Painter',
        'professionalId': 1,
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
        'professionalId': 2,
        'rating': 4.9,
        'reviews': 60,
        'price': 15,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Deep Cleaning',
        'professional': 'Emma Davis - Cleaner',
        'professionalId': 3,
        'rating': 4.8,
        'reviews': 55,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Office Cleaning',
        'professional': 'Sarah Martinez - Cleaner',
        'professionalId': 2,
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
        'professionalId': 1,
        'rating': 4.8,
        'reviews': 48,
        'price': 20,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Cabinet Installation',
        'professional': 'Thomas Taylor - Carpenter',
        'professionalId': 3,
        'rating': 4.9,
        'reviews': 52,
        'price': 30,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Door Repair',
        'professional': 'James Anderson - Carpenter',
        'professionalId': 1,
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
        'professionalId': 2,
        'rating': 4.9,
        'reviews': 65,
        'price': 50,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Portrait Photography',
        'professional': 'Anna White - Photographer',
        'professionalId': 3,
        'rating': 4.8,
        'reviews': 58,
        'price': 40,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Product Photography',
        'professional': 'Chris Lee - Photographer',
        'professionalId': 2,
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
        'professionalId': 2,
        'rating': 4.8,
        'reviews': 50,
        'price': 40,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'TV Wall Mount',
        'professional': 'Mark Clark - Technician',
        'professionalId': 1,
        'rating': 4.7,
        'reviews': 42,
        'price': 25,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Washing Machine Setup',
        'professional': 'Kevin Harris - Technician',
        'professionalId': 2,
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
        'professionalId': 2,
        'rating': 4.5,
        'reviews': 23,
        'price': 23,
        'image': ImagePath.pipeInstallation,
      },
      {
        'name': 'Washing Machine Repair',
        'professional': 'Abdur Rahman - Technician',
        'professionalId': 2,
        'rating': 4.5,
        'reviews': 23,
        'price': 23,
        'image': ImagePath.waterInstallation,
      },
      {
        'name': 'Refrigerator Repair',
        'professional': 'Daniel Moore - Technician',
        'professionalId': 3,
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