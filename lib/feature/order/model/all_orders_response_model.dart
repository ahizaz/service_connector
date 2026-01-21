import 'package:flutter/material.dart';

class AllOrdersResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<OrderModel> results;

  AllOrdersResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AllOrdersResponse.fromJson(Map<String, dynamic> json) {
    return AllOrdersResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

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
      orderId: json['order_id'] ?? 0,
      quotationId: json['quotation_id'] ?? 0,
      providerName: json['provider_name'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      receiverImage: json['receiver_image'],
      categoryName: json['category_name'] ?? '',
      serviceCost: json['service_cost']?.toString() ?? '0.00',
      providerAmount: json['provider_amount']?.toString() ?? '0.00',
      orderStatus: json['order_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      createdAt: json['created_at'] ?? '',
      completedAt: json['completed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'quotation_id': quotationId,
      'provider_name': providerName,
      'receiver_name': receiverName,
      'receiver_image': receiverImage,
      'category_name': categoryName,
      'service_cost': serviceCost,
      'provider_amount': providerAmount,
      'order_status': orderStatus,
      'payment_status': paymentStatus,
      'created_at': createdAt,
      'completed_at': completedAt,
    };
  }

  // Helper method to get display status
  String get displayStatus {
    switch (orderStatus.toLowerCase()) {
      case 'active':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return orderStatus;
    }
  }

  // Helper method to get status color
  Color getStatusColor() {
    switch (orderStatus.toLowerCase()) {
      case 'completed':
        return const Color(0xff4CAF50); // Green
      case 'active':
        return const Color(0xffFF9800); // Orange
      case 'cancelled':
        return const Color(0xffF44336); // Red
      default:
        return const Color(0xff2196F3); // Blue
    }
  }

  // Helper method to format created date
  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return createdAt;
    }
  }
}
