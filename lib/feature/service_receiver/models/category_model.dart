class CategoryModel {
  final String categoryName;
  final String categoryImage;
  final String createdAt;

  CategoryModel({
    required this.categoryName,
    required this.categoryImage,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
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
