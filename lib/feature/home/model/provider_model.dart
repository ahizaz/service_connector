import 'package:flutter/foundation.dart';

class ProviderModel {
  final int id;
  final String userId;
  final String userName;
  final String userEmail;
  final String categoryName;
  final String categoryImage;
  final String serviceTitle;
  final String providerDescription;
  final int  providerExperience;
  final int providerDoneWork;
  final String providerRating;
  final String providerServiceCharge;
  final String providerCountry;
  final String providerCity;
  final bool providerIsVerified;
  final int workImagesCount;
  final String createdAt;

  ProviderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.categoryName,
    required this.categoryImage,
    required this.serviceTitle,
    required this.providerDescription,
    required this.providerExperience,
    required this.providerDoneWork,
    required this.providerRating,
    required this.providerServiceCharge,
    required this.providerCity,
   required this.providerIsVerified,
    required this.workImagesCount,
    required this.createdAt, required this.providerCountry,
  });
  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      serviceTitle: json['service_title'] ?? '',
      providerDescription: json['provider_description'] ?? '',
      providerExperience: json['provider_experience'] ?? 0,
      providerDoneWork: json['provider_done_work'] ?? 0,
      providerRating: json['provider_rating']?.toString() ?? '0.00',
      providerServiceCharge: json['provider_service_charge']?.toString() ?? '0.00',
      providerCountry: json['provider_country'] ?? '',
      providerCity: json['provider_city'] ?? '',
      providerIsVerified: json['provider_is_verified'] ?? false,
      workImagesCount: json['work_images_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'category_name': categoryName,
      'category_image': categoryImage,
      'service_title': serviceTitle,
      'provider_description': providerDescription,
      'provider_experience': providerExperience,
      'provider_done_work': providerDoneWork,
      'provider_rating': providerRating,
      'provider_service_charge': providerServiceCharge,
      'provider_country': providerCountry,
      'provider_city': providerCity,
      'provider_is_verified': providerIsVerified,
      'work_images_count': workImagesCount,
      'created_at': createdAt,
    };
  }

}