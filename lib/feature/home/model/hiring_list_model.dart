class HiringListModel {
  final int receiverId;
  final String receiverName;
  final String? receiverImage;
  final String serviceCategory;
  final String orderStatus;
  final String paymentStatus;
  final String serviceCost;
  final String providerAmount;
  final String orderDate;
  final String? completedAt;

  HiringListModel({
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
    required this.serviceCategory,
    required this.orderStatus,
    required this.paymentStatus,
    required this.serviceCost,
    required this.providerAmount,
    required this.orderDate,
    this.completedAt,
  });

  factory HiringListModel.fromJson(Map<String, dynamic> json) {
    return HiringListModel(
      receiverId: json['receiver_id'] ?? 0,
      receiverName: json['receiver_name'] ?? '',
      receiverImage: json['receiver_image'],
      serviceCategory: json['service_category'] ?? '',
      orderStatus: json['order_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      serviceCost: json['service_cost']?.toString() ?? '0.00',
      providerAmount: json['provider_amount']?.toString() ?? '0.00',
      orderDate: json['order_date'] ?? '',
      completedAt: json['completed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'receiver_image': receiverImage,
      'service_category': serviceCategory,
      'order_status': orderStatus,
      'payment_status': paymentStatus,
      'service_cost': serviceCost,
      'provider_amount': providerAmount,
      'order_date': orderDate,
      'completed_at': completedAt,
    };
  }

  // Helper getters for status checks
  bool get isActive => orderStatus.toLowerCase() == 'active';
  bool get isCompleted => orderStatus.toLowerCase() == 'completed';
  bool get isCancelled => orderStatus.toLowerCase() == 'cancelled';
  
  bool get isPaid => paymentStatus.toLowerCase() == 'paid';
  bool get isUnpaid => paymentStatus.toLowerCase() == 'unpaid';
}
