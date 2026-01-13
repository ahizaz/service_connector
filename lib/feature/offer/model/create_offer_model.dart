class CreateOfferModel {
  final String receiverUserId;
  final int serviceCategory;
  final String serviceDescription;
  final String serviceCost;
  final String serviceTimeline;
  final String termsConditions;
  final String urgencyType;

  CreateOfferModel({
    required this.receiverUserId,
    required this.serviceCategory,
    required this.serviceDescription,
    required this.serviceCost,
    required this.serviceTimeline,
    required this.termsConditions,
    required this.urgencyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiver_user_id': receiverUserId,
      'service_category': serviceCategory,
      'service_description': serviceDescription,
      'service_cost': serviceCost,
      'service_timeline': serviceTimeline,
      'terms_conditions': termsConditions,
      'urgency_type': urgencyType,
    };
  }

  factory CreateOfferModel.fromJson(Map<String, dynamic> json) {
    return CreateOfferModel(
      receiverUserId: json['receiver_user_id'] ?? '',
      serviceCategory: json['service_category'] ?? 0,
      serviceDescription: json['service_description'] ?? '',
      serviceCost: json['service_cost'] ?? '',
      serviceTimeline: json['service_timeline'] ?? '',
      termsConditions: json['terms_conditions'] ?? '',
      urgencyType: json['urgency_type'] ?? 'normal',
    );
  }
}
