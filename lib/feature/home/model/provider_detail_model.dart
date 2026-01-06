class ProviderDetailModel {
  final int id;
  final User user;
  final ServiceCategory serviceCategory;
  final String serviceTitle;
  final String providerDescription;
  final int providerExperience;
  final int providerDoneWork;
  final String providerRating;
  final String providerServiceCharge;
  final String providerLanguage;
  final String providerLicenceNumber;
  final String providerCountry;
  final String providerCity;
  final String providerServiceArea;
  final int providerTotalHired;
  final String providerTotalEarnings;
  final String providerAvailableBalance;
  final bool providerIsVerified;
  final List<String> keywords;
  final List<WorkImage> workImages;
  final List<Document> documents;
  final String createdAt;
  final String updatedAt;

  ProviderDetailModel({
    required this.id,
    required this.user,
    required this.serviceCategory,
    required this.serviceTitle,
    required this.providerDescription,
    required this.providerExperience,
    required this.providerDoneWork,
    required this.providerRating,
    required this.providerServiceCharge,
    required this.providerLanguage,
    required this.providerLicenceNumber,
    required this.providerCountry,
    required this.providerCity,
    required this.providerServiceArea,
    required this.providerTotalHired,
    required this.providerTotalEarnings,
    required this.providerAvailableBalance,
    required this.providerIsVerified,
    required this.keywords,
    required this.workImages,
    required this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderDetailModel.fromJson(Map<String, dynamic> json) {
    return ProviderDetailModel(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      serviceCategory: ServiceCategory.fromJson(json['service_category'] ?? {}),
      serviceTitle: json['service_title'] ?? '',
      providerDescription: json['provider_description'] ?? '',
      providerExperience: json['provider_experience'] ?? 0,
      providerDoneWork: json['provider_done_work'] ?? 0,
      providerRating: json['provider_rating']?.toString() ?? '0.00',
      providerServiceCharge: json['provider_service_charge']?.toString() ?? '0.00',
      providerLanguage: json['provider_language'] ?? '',
      providerLicenceNumber: json['provider_licence_number'] ?? '',
      providerCountry: json['provider_country'] ?? '',
      providerCity: json['provider_city'] ?? '',
      providerServiceArea: json['provider_service_area'] ?? '',
      providerTotalHired: json['provider_total_hired'] ?? 0,
      providerTotalEarnings: json['provider_total_earnings']?.toString() ?? '0.00',
      providerAvailableBalance: json['provider_available_balance']?.toString() ?? '0.00',
      providerIsVerified: json['provider_is_verified'] ?? false,
      keywords: (json['keywords'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      workImages: (json['work_images'] as List<dynamic>?)?.map((e) => WorkImage.fromJson(e)).toList() ?? [],
      documents: (json['documents'] as List<dynamic>?)?.map((e) => Document.fromJson(e)).toList() ?? [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'service_category': serviceCategory.toJson(),
      'service_title': serviceTitle,
      'provider_description': providerDescription,
      'provider_experience': providerExperience,
      'provider_done_work': providerDoneWork,
      'provider_rating': providerRating,
      'provider_service_charge': providerServiceCharge,
      'provider_language': providerLanguage,
      'provider_licence_number': providerLicenceNumber,
      'provider_country': providerCountry,
      'provider_city': providerCity,
      'provider_service_area': providerServiceArea,
      'provider_total_hired': providerTotalHired,
      'provider_total_earnings': providerTotalEarnings,
      'provider_available_balance': providerAvailableBalance,
      'provider_is_verified': providerIsVerified,
      'keywords': keywords,
      'work_images': workImages.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}

class ServiceCategory {
  final String categoryName;
  final String categoryImage;
  final String createdAt;

  ServiceCategory({
    required this.categoryName,
    required this.categoryImage,
    required this.createdAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'category_image': categoryImage,
      'created_at': createdAt,
    };
  }
}

class WorkImage {
  final int id;
  final String image;
  final String uploadedAt;

  WorkImage({
    required this.id,
    required this.image,
    required this.uploadedAt,
  });

  factory WorkImage.fromJson(Map<String, dynamic> json) {
    return WorkImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'uploaded_at': uploadedAt,
    };
  }
}

class Document {
  final String documentType;
  final String documentFront;
  final String? verificationId;
  final String status;
  final String uploadedAt;

  Document({
    required this.documentType,
    required this.documentFront,
    this.verificationId,
    required this.status,
    required this.uploadedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentType: json['document_type'] ?? '',
      documentFront: json['document_front'] ?? '',
      verificationId: json['verification_id']?.toString(),
      status: json['status'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_front': documentFront,
      'verification_id': verificationId,
      'status': status,
      'uploaded_at': uploadedAt,
    };
  }
}
