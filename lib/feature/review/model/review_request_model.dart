class ReviewRequestModel {
  final String providerUserUuid;
  final int order;
  final int rating;
  final String reviewText;

  ReviewRequestModel({
    required this.providerUserUuid,
    required this.order,
    required this.rating,
    required this.reviewText,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_user_uuid': providerUserUuid,
      'order': order,
      'rating': rating,
      'review_text': reviewText,
    };
  }
}
