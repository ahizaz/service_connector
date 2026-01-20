class AcceptedOrderModel {
  final String quotationId;
  final String receiverUserId;
  final int serviceCategory;
  final String serviceCost;
  final String paymentStatus;
  final String serviceTimeline;
  final String createdAt;
  final String? termsConditions;
  final String? serviceDescription;

  AcceptedOrderModel({
    required this.quotationId,
    required this.receiverUserId,
    required this.serviceCategory,
    required this.serviceCost,
    required this.paymentStatus,
    required this.serviceTimeline,
    required this.createdAt,
    this.termsConditions,
    this.serviceDescription,
  });

  factory AcceptedOrderModel.fromJson(Map<String, dynamic> json) {
    // Handle both flat and nested response structures
    int categoryId = 0;
    if (json['service_category'] is Map) {
      categoryId = 0; // Will use category_name if available
    } else {
      categoryId = json['service_category'] ?? 0;
    }

    return AcceptedOrderModel(
      quotationId: (json['id'] ?? json['quotation_id'])?.toString() ?? '',
      receiverUserId: json['receiver_user_id']?.toString() ?? '',
      serviceCategory: categoryId,
      serviceCost: json['service_cost']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      serviceTimeline: json['service_timeline']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      termsConditions: json['terms_conditions']?.toString(),
      serviceDescription: json['service_description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quotation_id': quotationId,
      'receiver_user_id': receiverUserId,
      'service_category': serviceCategory,
      'service_cost': serviceCost,
      'payment_status': paymentStatus,
      'service_timeline': serviceTimeline,
      'created_at': createdAt,
      'terms_conditions': termsConditions,
      'service_description': serviceDescription,
    };
  }

  // Get category name from category ID
  String getCategoryName() {
    switch (serviceCategory) {
      case 1:
        return 'Cleaning';
      case 2:
        return 'Concrete';
      case 3:
        return 'Electrical';
      case 4:
        return 'Handyperson';
      case 5:
        return 'HVAC';
      case 6:
        return 'Landscaping';
      case 7:
        return 'Painting';
      case 8:
        return 'Plumbing';
      case 9:
        return 'Remodeling';
      case 10:
        return 'Roofing';
      case 11:
        return 'Windows';
      default:
        return 'Service Category $serviceCategory';
    }
  }
}
