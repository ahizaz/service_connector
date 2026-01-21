class OfferListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<OfferModel> results;

  OfferListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory OfferListResponse.fromJson(Map<String, dynamic> json) {
    return OfferListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => OfferModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}

class OfferModel {
  final int id;
  final String providerUserId;
  final String receiverUserId;
  final String providerName;
  final String receiverName;
  final String categoryName;
  final String serviceCost;
  final String serviceTimeline;
  final String quotationStatus;
  final String paymentStatus;
  final String createdAt;

  OfferModel({
    required this.id,
    required this.providerUserId,
    required this.receiverUserId,
    required this.providerName,
    required this.receiverName,
    required this.categoryName,
    required this.serviceCost,
    required this.serviceTimeline,
    required this.quotationStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? 0,
      providerUserId: json['provider_user_id'] ?? '',
      receiverUserId: json['receiver_user_id'] ?? '',
      providerName: json['provider_name'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      serviceCost: json['service_cost'] ?? '0.00',
      serviceTimeline: json['service_timeline'] ?? '',
      quotationStatus: json['quotation_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_user_id': providerUserId,
      'receiver_user_id': receiverUserId,
      'provider_name': providerName,
      'receiver_name': receiverName,
      'category_name': categoryName,
      'service_cost': serviceCost,
      'service_timeline': serviceTimeline,
      'quotation_status': quotationStatus,
      'payment_status': paymentStatus,
      'created_at': createdAt,
    };
  }

  bool get isAccepted => quotationStatus.toLowerCase() == 'accepted';
  bool get isPaid => paymentStatus.toLowerCase() == 'paid';
  bool get isCanceled => quotationStatus.toLowerCase() == 'canceled';
}
