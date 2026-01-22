class OrderModel {
  final int orderId;
  final int quotationId;
  final String providerName;
  final String receiverName;
  final String? receiverImage;
  final String categoryName;
  final String serviceCost;
  final String providerAmount;
  final String orderStatus;
  final String paymentStatus;
  final String createdAt;
  final String? completedAt;
  OrderModel({
    required this.orderId,
    required this.quotationId,
    required this.providerName,
    required this.receiverName,
    this.receiverImage,
    required this.categoryName,
    required this.serviceCost,
    required this.providerAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
    this.completedAt,
  });
    factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      quotationId: json['quotation_id'],
      providerName: json['provider_name'],
      receiverName: json['receiver_name'],
      receiverImage: json['receiver_image'],
      categoryName: json['category_name'],
      serviceCost: json['service_cost'],
      providerAmount: json['provider_amount'],
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'],
      createdAt: json['created_at'],
      completedAt: json['completed_at'],
    );
  }
}