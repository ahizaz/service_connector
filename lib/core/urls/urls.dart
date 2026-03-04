import 'package:flutter_dotenv/flutter_dotenv.dart';

class Url {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? '';
  static String get wsBaseUrl =>
      dotenv.env['WEBSOCKET_URL'] ?? '';

  static String get signUp => '$baseUrl/auth/signup/';
  static String get verifyScreen => '$baseUrl/auth/verify-otp/';
  static String get resendOtp => '$baseUrl/auth/resend-otp/';
  static String get forgetPassword => '$baseUrl/auth/forgot-password/';
  static String get resetPassword => '$baseUrl/auth/reset-password/';
  static String get updateProfile => '$baseUrl/auth/profile/';
  static String get login => '$baseUrl/auth/login/';
  static String get createServiceProvider => '$baseUrl/provider/providers/';

  // Dynamic submit document URL based on provider ID
  static String submitDocument(int providerId) =>
      '$baseUrl/provider/providers/$providerId/submit-document/';
  static String uploadWorkImage(int providerId) =>
      '$baseUrl/provider/providers/$providerId/upload-work-image/';
  static String get getAllcatagories => '$baseUrl/provider/categories/';
  static String get getAllproviders => '$baseUrl/provider/providers/';

  // Dynamic provider details URL based on provider ID
  static String getProviderDetails(int providerId) =>
      '$baseUrl/provider/providers/$providerId/';
  static String get createConversation => '$baseUrl/message/conversations/';
  static String get getAllConversation => '$baseUrl/message/conversations/';
  static String acceptdeclineConversation(int conversationId) =>
      '$baseUrl/message/conversations/$conversationId/update-status/';
  static String getSpecificConversation(int conversationId) =>
      '$baseUrl/message/messages/?conversation_id=$conversationId';
  static String get sendMessage => '$baseUrl/message/messages/';
  static String get createOffer => '$baseUrl/offer/quotations/';
  static String updateOfferStatus(int quotationId) =>
      '$baseUrl/offer/quotations/$quotationId/update-status/';
  static String allacceptedOrder(String receiverUserId) =>
      '$baseUrl/offer/quotations/accepted-for-order/?receiver_user_id=$receiverUserId';
  static String get createOrder => '$baseUrl/offer/orders/';
  static String get getAllofferlist => '$baseUrl/offer/quotations/';
  static String cancelquotebyReceiver(int quotationId) =>
      '$baseUrl/offer/quotations/$quotationId/cancel/';
  static String get getEarnings =>
      '$baseUrl/offer/provider-dashboard/earnings/';
  static String get getHiringList =>
      '$baseUrl/offer/provider-dashboard/hiring-list/';
  static String get getAllorder => '$baseUrl/offer/orders/';
  static String get receiverReview => '$baseUrl/offer/reviews/';
  static String getProviderReviews(String providerUserId) =>
      '$baseUrl/offer/reviews/by-provider-user/?provider_user_id=$providerUserId';
  static String get providerBankdetails => '$baseUrl/provider/bank-details/';
}
