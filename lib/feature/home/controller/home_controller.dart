import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/home/model/provider_model.dart';
import 'package:service_connect/feature/home/repository/provider_repositroy.dart';
import 'package:service_connect/feature/service_receiver/controller/category_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  final ProviderRepository providerRepository = ProviderRepository();
  final RxList<ProviderModel> allProviders = <ProviderModel>[].obs;
  final RxBool isLoadingProviders = false.obs;

  // Service provider mode
  final RxBool isServiceProvider = false.obs;

  // Category controller for API data
  final CategoryController categoryController = Get.put(CategoryController());

  // Dashboard stats (for service providers)
  final RxDouble availableWithdraw = 0.0.obs;
  final RxDouble earningInMonth = 0.0.obs;
  final RxInt activeHire = 0.obs;
  final RxInt cancelHire = 0.obs;
  // Header / profile stats shown in provider header
  final RxInt totalHire = 0.obs;
  final RxDouble totalEarning = 0.0.obs;
  final RxDouble providerRating = 0.0.obs;
  final RxInt successRate = 0.obs;

  // Text data
  final String greetingText = "Hey, Glad You're Here";
  final RxString userName = "Johnson Mate".obs;

  Future<void> _loadUserNameFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('userName');
      if (saved != null && saved.isNotEmpty) userName.value = saved;
    } catch (e) {
      debugPrint('Failed to load userName from prefs: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    _initializeHomeData();
  }

  // Initialize all home data
  Future<void> _initializeHomeData() async {
    try {
      EasyLoading.show(status: 'Loading...');
      
      // Load data in parallel but don't let one failure stop others
      await Future.wait([
        loadServiceProviderMode(),
        _loadUserNameFromPrefs(),
        categoryController.fetchCategories(),
        fetchAllProviders(),
      ], eagerError: false);
      
      // Load dashboard data separately - it might fail if no provider profile exists
      await loadDashboardData().catchError((e) {
        debugPrint('Dashboard data failed to load, continuing anyway: $e');
      });
      
    } catch (e) {
      debugPrint('Error initializing home data: $e');
      // Don't show error to user - individual functions handle their own errors
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchAllProviders() async {
    try {
      // isLoadingProviders true করে দিলাম, মানে loading শুরু হয়েছে
      isLoadingProviders.value = true;
      EasyLoading.show(status: 'Loading providers...');

      debugPrint('==========================================');
      debugPrint('Starting to fetch all providers from API');
      debugPrint('==========================================');

      // providerRepository.getAllProviders() call করে API থেকে data নিচ্ছি
      // await মানে হলো এই line এ wait করবে যতক্ষণ না data আসে
      final List<ProviderModel> providers = await providerRepository
          .getAllProviders();

      debugPrint('==========================================');
      debugPrint('Successfully fetched ${providers.length} providers');
      debugPrint('==========================================');

      // allProviders list এ নতুন data assign করছি
      // .value দিয়ে RxList এর value change করা হয়
      allProviders.value = providers;

      // যদি data না আসে তাহলে empty message দেখাচ্ছি
      if (providers.isEmpty) {
        debugPrint('No providers found in the response');
      } else {
        // প্রথম provider এর info print করছি check করার জন্য
        debugPrint('First provider: ${providers[0].userName}');
      }

      EasyLoading.dismiss();
    } catch (e) {
      // যদি কোনো error হয় তাহলে এখানে আসবে
      debugPrint('==========================================');
      debugPrint('Error in fetchAllProviders: $e');
      debugPrint('==========================================');

      EasyLoading.dismiss();
      EasyLoading.showError('Failed to load providers');
    } finally {
      // finally block সবসময় execute হবে, error হোক বা না হোক
      // Loading state false করে দিচ্ছি
      isLoadingProviders.value = false;
    }
  }

  // Reload mode when screen is revisited
  void reloadMode() {
    loadServiceProviderMode();
    // also refresh dashboard data when returning to screen
    loadDashboardData();
  }

  // Reload all home data after login
  Future<void> reloadHomeData() async {
    await _initializeHomeData();
  }

  /// Load provider dashboard data.
  /// Currently this sets static/sample values. Replace with API call as needed.
  Future<void> loadDashboardData() async {
    try {
      debugPrint('=================================');
      debugPrint('Loading dashboard data from API...');
      debugPrint('=================================');
      
      EasyLoading.show(status: 'Loading dashboard...');
      
      final earningsData = await providerRepository.getEarnings();
      
      debugPrint('=================================');
      debugPrint('Earnings Data Received:');
      debugPrint('Total Earnings: ${earningsData.totalEarnings}');
      debugPrint('Available Balance: ${earningsData.availableBalance}');
      debugPrint('Last Month Earnings: ${earningsData.lastMonthEarnings}');
      debugPrint('Active Hires: ${earningsData.activeHires}');
      debugPrint('Cancelled Works: ${earningsData.cancelledWorks}');
      debugPrint('Total Hired: ${earningsData.totalHired}');
      debugPrint('=================================');
      
      availableWithdraw.value = double.tryParse(earningsData.availableBalance) ?? 0.0;
      earningInMonth.value = double.tryParse(earningsData.lastMonthEarnings) ?? 0.0;
      activeHire.value = earningsData.activeHires;
      cancelHire.value = earningsData.cancelledWorks;
      
      // Sample header/profile values
      totalHire.value = earningsData.totalHired;
      totalEarning.value = double.tryParse(earningsData.totalEarnings) ?? 0.0;
      // Rating and success rate might come from different endpoint
      providerRating.value = 4.8; // Keep as default for now
      successRate.value = 96; // Keep as default for now
      
      EasyLoading.dismiss();
      
      debugPrint('=================================');
      debugPrint('Dashboard data loaded successfully');
      debugPrint('=================================');
    } catch (e) {
      debugPrint('=================================');
      debugPrint('Failed to load dashboard data: $e');
      debugPrint('=================================');
      
      EasyLoading.dismiss();
      
      // Don't show error dialog - just set default values
      // This can happen if user hasn't created provider profile yet
      
      // Set default values on error
      availableWithdraw.value = 0.0;
      earningInMonth.value = 0.0;
      activeHire.value = 0;
      cancelHire.value = 0;
      totalHire.value = 0;
      totalEarning.value = 0.0;
      providerRating.value = 0.0;
      successRate.value = 0;
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
      'overview':
          'Consequat velit qui adipisicing sunt do reprehenderit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex dolore esse. Consequat velit qui adipisicing et voluptate duis sit esse aliqua esse ex dolore esse.',
      'services': [
        'Pipe Installation',
        'Leak Repair',
        'Water Heater Installation',
        'Bathroom Fittings',
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
      'overview':
          'Expert in computer repair and washing machine services. Highly skilled technician with years of experience in electronics and appliance repair.',
      'services': [
        'Computer Repair',
        'Washing Machine Repair',
        'Laptop Servicing',
        'Hardware Installation',
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
      'overview':
          'Professional plumber with extensive experience in residential and commercial plumbing. Specialized in pipe installation and water systems.',
      'services': [
        'Pipe Installation',
        'Sewer Line Maintenance',
        'Water Tank Cleaning',
        'Emergency Repairs',
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
      'category': 'Repairing',
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing',
    },
    {
      'name': 'Computer Repair',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing',
    },
    {
      'name': 'Pipe Installation',
      'professional': 'Ramesh Kumar',
      'professionalId': 1,
      'rating': 4.8,
      'experience': 4,
      'workDone': 360,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Plumber',
    },
    {
      'name': 'Bathroom Fittings',
      'professional': 'Johnson Mate',
      'professionalId': 3,
      'rating': 4.8,
      'experience': 6,
      'workDone': 450,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Plumber',
    },
    {
      'name': 'Washing Machine...',
      'professional': 'Abdur Rahman',
      'professionalId': 2,
      'rating': 4.5,
      'experience': 5,
      'workDone': 280,
      'image': 'assets/images/userpicreparing.png',
      'category': 'Repairing',
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
