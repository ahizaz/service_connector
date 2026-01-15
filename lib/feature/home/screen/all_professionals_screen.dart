import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/search_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';
import 'package:service_connect/feature/conversation/repository/conversation_repository.dart';
import 'package:service_connect/feature/chat/screen/chat_detail_screen.dart';
import 'package:service_connect/feature/chat/controller/chat_controller.dart';
import 'package:service_connect/feature/chat/model/chat_message_model.dart';

class AllProfessionalsScreen extends StatefulWidget {
  const AllProfessionalsScreen({super.key});

  @override
  State<AllProfessionalsScreen> createState() => _AllProfessionalsScreenState();
}

class _AllProfessionalsScreenState extends State<AllProfessionalsScreen> {
  final ConversationRepository _conversationRepository = ConversationRepository();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<HomeController>();
    // Fetch all providers when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllProviders();
    });
  }

  /// Handle Book Now button click
  Future<void> _handleBookNow(String providerId, String providerName) async {
    try {
      EasyLoading.show(status: 'Creating conversation...');
      
      debugPrint('=================================');
      debugPrint('Book Now clicked');
      debugPrint('Provider ID: $providerId');
      debugPrint('Provider Name: $providerName');
      debugPrint('=================================');
      
      // Create conversation via API
      final response = await _conversationRepository.createConversation(providerId);
      
      EasyLoading.dismiss();
      
      debugPrint('=================================');
      debugPrint('Conversation created successfully');
      debugPrint('Conversation ID: ${response.data.conversationId}');
      debugPrint('Status: ${response.data.conversationStatus}');
      debugPrint('=================================');
      
      // Get chat controller
      final chatController = Get.find<ChatController>();
      
      // Create ChatUser from conversation data
      final chatUser = ChatUser(
        id: response.data.messageReceiver.id,
        name: response.data.messageReceiver.name,
        profileImage: '', // You can add profile image if available
        lastMessage: response.data.messages.isNotEmpty 
            ? response.data.messages.last.messageText 
            : 'Start conversation',
        time: 'now',
        unreadCount: 0,
        isOnline: false,
        isVerified: false,
        conversationId: response.data.conversationId,
        conversationStatus: response.data.conversationStatus,
        serviceTitle: response.data.messageSender.serviceTitle,
      );
      
      // Set the current chat user
      chatController.openChat(chatUser);
      
      // Refresh conversations list to show new conversation in inbox
      chatController.fetchAllConversations();
      
      // Navigate to chat details screen
      Get.to(() => ChatDetailScreen());
      
      // Show success message
      Get.snackbar(
        'Success',
        'Conversation started with $providerName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error creating conversation: $e');
      
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
            backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff252525)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'All Professional',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff252525),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Color(0xff252525)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar (opens dedicated search screen)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Color(0xffE0E0E0)),
              ),
              child: TextField(
                readOnly: true,
                onTap: () => Get.to(() => const SearchScreen()),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search for plumber, electrician...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff999999),
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xff999999)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Grid of professionals
            Expanded(
              child: Obx(() {
                if (controller.isLoadingProviders.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff252525),
                    ),
                  );
                }

                if (controller.allProviders.isEmpty) {
                  return Center(
                    child: Text(
                      'No professionals found',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: Color(0xff999999),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 164 / 190,
                  ),
                  itemCount: controller.allProviders.length,
                  itemBuilder: (context, index) {
                    final provider = controller.allProviders[index];
                    debugPrint('Displaying provider: ${provider.userName}');
                    
                    return ProfessionalCardWidget(
                      name: provider.userName,
                      professional: provider.categoryName,
                      rating: double.tryParse(provider.providerRating) ?? 0.0,
                      price: '\$${provider.providerServiceCharge}/hour',
                      experience: provider.providerExperience,
                      workDone: provider.providerDoneWork,
                      image: provider.userImage ?? '',
                      category: provider.categoryName,
                      onTap: () {
                        debugPrint('Tapped on provider: ${provider.userName} (ID: ${provider.id})');
                        // Navigate to professional details screen
                        Get.to(() => ProfessionalDetailsScreen(
                          professionalId: provider.id,
                        ));
                      },
                      onBookNow: () {
                        debugPrint('Book now clicked for provider: ${provider.userName}');
                        // Call the API to create conversation and navigate to chat
                        _handleBookNow(provider.userId, provider.userName);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
