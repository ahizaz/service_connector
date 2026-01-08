class Url {
  static const String baseUrl = "https://6zpmb4x8-8009.inc1.devtunnels.ms";
  static const String signUp = "$baseUrl/auth/signup/";
  static const String verifyScreen = "$baseUrl/auth/verify-otp/";
  static const String resendOtp = "$baseUrl/auth/resend-otp/";
  static const String forgetPassword = "$baseUrl/auth/forgot-password/";
  static const String resetPassword = "$baseUrl/auth/reset-password/";
  static const String updateProfile = "$baseUrl/auth/profile/";
  static const String login = "$baseUrl/auth/login/";
  static const String createServiceProvider = "$baseUrl/provider/providers/";

  // Dynamic submit document URL based on provider ID
  static String submitDocument(int providerId) =>
      "$baseUrl/provider/providers/$providerId/submit-document/";
      static String uploadWorkImage(int providerId)=>"$baseUrl/provider/providers/$providerId/upload-work-image/";
      static const String getAllcatagories = "$baseUrl/provider/categories/";
      static const String getAllproviders = "$baseUrl/provider/providers/";
      
      // Dynamic provider details URL based on provider ID
      static String getProviderDetails(int providerId) => "$baseUrl/provider/providers/$providerId/";
      static String createConversation= "$baseUrl/message/conversations/";
      static String getAllConversation = "$baseUrl/message/conversations/";
      static String acceptdeclineConversation(int conversationId) => "$baseUrl/message/conversations/$conversationId/update-status/";
      static String getSpecificConversation(int conversationId) => "$baseUrl/message/messages/?conversation_id=$conversationId";



}
