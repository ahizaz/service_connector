import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  
  // Observable for selected tab
  var selectedTab = 0.obs;
  
  // Total statistics
  final int totalHire = 23;
  final double totalSpend = 2012.00;
  
  // All orders
  final List<Map<String, dynamic>> allOrders = [
    {
      'title': 'Pipe Plumbing',
      'subtitle': 'Pipe Plumbing',
      'professional': 'Abdur Rahman - Plumber',
      'description': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air c...',
      'fullDescription': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems. My work involves diagnosing issues, performing routine check-ups, and ensuring optimal performance of cooling units. I also provide recommendations for energy efficiency and help customers understand how to operate their systems effectively. My goal is to ensure that every client enjoys a comfortable indoor environment.',
      'price': 215.00,
      'date': '09/January',
      'time': '10:00 AM',
      'status': 'Active',
      'image': 'assets/images/userpicreparing.png',
    },
    {
      'title': 'Electricity mechanic',
      'subtitle': 'Electricity mechanic',
      'professional': 'Abdur Rahman - Electrician',
      'description': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air c...',
      'fullDescription': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems. My work involves diagnosing issues, performing routine check-ups, and ensuring optimal performance of cooling units. I also provide recommendations for energy efficiency and help customers understand how to operate their systems effectively. My goal is to ensure that every client enjoys a comfortable indoor environment.',
      'price': 526.00,
      'date': '09/March',
      'time': '12:00 AM',
      'status': 'Active',
      'image': 'assets/images/userpicreparing.png',
    },
    {
      'title': 'HVAC Specialist',
      'subtitle': 'HVAC Specialist',
      'professional': 'Abdur Rahman - HVAC Technician',
      'description': 'As an HVAC specialist, I focus on the integration of heating, ventilation, and air co...',
      'fullDescription': 'As an HVAC specialist, I focus on the integration of heating, ventilation, and air conditioning systems to create optimal indoor environments. My expertise includes system design, installation, and maintenance, ensuring energy efficiency and comfort for residential and commercial clients.',
      'price': 320.00,
      'date': '09/March',
      'time': '12:00 AM',
      'status': 'Active',
      'image': 'assets/images/userpicreparing.png',
    },
    {
      'title': 'Bathroom Fittings',
      'subtitle': 'Bathroom Fittings',
      'professional': 'Abdur Rahman - Plumber',
      'description': 'And Balcony Plumber',
      'fullDescription': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems. My work involves diagnosing issues, performing routine check-ups, and ensuring optimal performance of cooling units. I also provide recommendations for energy efficiency and help customers understand how to operate their systems effectively. My goal is to ensure that every client enjoys a comfortable indoor environment.',
      'price': 215.00,
      'date': '09/January',
      'time': '10:00 AM',
      'status': 'Active',
      'image': 'assets/images/userpicreparing.png',
    },
  ];
  
  // Active orders
  List<Map<String, dynamic>> get activeOrders => 
      allOrders.where((order) => order['status'] == 'Active').toList();
  
  // Completed orders
  final List<Map<String, dynamic>> completedOrders = [
    {
      'title': 'Pipe Plumbing',
      'subtitle': 'Pipe Plumbing',
      'professional': 'Abdur Rahman - Plumber',
      'description': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air c...',
      'fullDescription': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems. My work involves diagnosing issues, performing routine check-ups, and ensuring optimal performance of cooling units. I also provide recommendations for energy efficiency and help customers understand how to operate their systems effectively. My goal is to ensure that every client enjoys a comfortable indoor environment.',
      'price': 215.00,
      'date': '09/January',
      'time': '10:00 AM',
      'status': 'Complete',
      'image': 'assets/images/userpicreparing.png',
    },
    {
      'title': 'Electricity mechanic',
      'subtitle': 'Electricity mechanic',
      'professional': 'Abdur Rahman - Electrician',
      'description': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air c...',
      'fullDescription': 'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems. My work involves diagnosing issues, performing routine check-ups, and ensuring optimal performance of cooling units. I also provide recommendations for energy efficiency and help customers understand how to operate their systems effectively. My goal is to ensure that every client enjoys a comfortable indoor environment.',
      'price': 526.00,
      'date': '09/March',
      'time': '12:00 AM',
      'status': 'Complete',
      'image': 'assets/images/userpicreparing.png',
    },
    {
      'title': 'HVAC Specialist',
      'subtitle': 'HVAC Specialist',
      'professional': 'Abdur Rahman - HVAC Technician',
      'description': 'As an HVAC specialist, I focus on the integration of heating, ventilation, and air co...',
      'fullDescription': 'As an HVAC specialist, I focus on the integration of heating, ventilation, and air conditioning systems to create optimal indoor environments. My expertise includes system design, installation, and maintenance, ensuring energy efficiency and comfort for residential and commercial clients.',
      'price': 320.00,
      'date': '09/March',
      'time': '12:00 AM',
      'status': 'Complete',
      'image': 'assets/images/userpicreparing.png',
    },
  ];
  
  // Cancelled orders
  final List<Map<String, dynamic>> cancelledOrders = [];
  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
  }
  
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
  
  // Get orders based on selected tab
  List<Map<String, dynamic>> getOrdersByTab(int index) {
    switch (index) {
      case 0: // All
        return [...activeOrders, ...completedOrders, ...cancelledOrders];
      case 1: // Active
        return activeOrders;
      case 2: // Complete
        return completedOrders;
      case 3: // Cancelled
        return cancelledOrders;
      default:
        return allOrders;
    }
  }
}