import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';
import 'package:service_connect/feature/home/screen/all_professionals_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';
import 'package:service_connect/feature/conversation/repository/conversation_repository.dart';
import 'package:service_connect/feature/chat/screen/chat_detail_screen.dart';
import 'package:service_connect/feature/chat/controller/chat_controller.dart';
import 'package:service_connect/feature/chat/model/chat_message_model.dart';

class TopRatedProfessionalsWidget extends StatelessWidget {
  final HomeController controller;
  final ConversationRepository _conversationRepository = ConversationRepository();
  
  TopRatedProfessionalsWidget({super.key, required this.controller});

  /// Handle Book Now button click
  Future<void> _handleBookNow(String providerId, String providerName) async {
    try {
      EasyLoading.show(status: 'Creating conversation...');
      
      debugPrint('=================================');
      debugPrint('Book Now clicked from home');
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All Professional", style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xff252525),
              )),
              GestureDetector(
                onTap: () => Get.to(() => AllProfessionalsScreen()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See all",
                      style: GoogleFonts.roboto(
                        color: Color(0xffCC0000),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: Color(0xffCC0000),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // SizedBox(
        //   height: 240.h,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //     itemCount: controller.topRatedProfessionals.length,
        //     itemBuilder: (context, index) {
        //       final professional = controller.topRatedProfessionals[index];
        //       return Padding(
        //         padding: EdgeInsets.only(right: 16.w),
        //         child: GestureDetector(
        //           onTap: () {
        //             Get.to(() => ProfessionalDetailsScreen(
        //               professionalId: professional['professionalId'],
        //             ));
        //           },
        //           child: ProfessionalCardWidget(
        //             name: professional['name'],
        //             professional: professional['professional'],
        //             rating: professional['rating'].toDouble(),
        //             price: professional['price'] != null ? '\$${professional['price']}/hour' : null,
        //             experience: professional['experience'],
        //             workDone: professional['workDone'],
        //             image: professional['image'],
        //             category: professional['category'],
        //             onBookNow: () {
        //               Get.defaultDialog(
        //                 title: 'Confirm Booking',
        //                 middleText: 'Do you want to book ${professional['name']}?',
        //                 textConfirm: 'Yes',
        //                 textCancel: 'No',
        //                 onConfirm: () {
        //                   Get.back();
        //                   Get.snackbar(
        //                     'Booked',
        //                     '${professional['name']} booked successfully',
        //                     snackPosition: SnackPosition.BOTTOM,
        //                     backgroundColor: Colors.green.withOpacity(0.9),
        //                     colorText: Colors.white,
        //                   );
                         
        //                 },
        //               );
        //             },
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Obx((){
       if(controller.isLoadingProviders.value){
        return SizedBox(
          height: 240.h,
          child: Center(
            child: CircularProgressIndicator(
                color: Color(0xffCC0000),
            ),
          ),
        );
       }
       if(controller.allProviders.isEmpty){
          return SizedBox(
              height: 240.h,
              child: Center(
                child: Text(
                  'No professionals available',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff999999),
                  ),
                ),
              ),
            );
       }
       return SizedBox(
       height: 240.h,
       child: ListView.builder(
         scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: controller.allProviders.length,
        itemBuilder: (context,index){
        final provider = controller.allProviders[index];
        debugPrint('Building card for: ${provider.userName}');
        return Padding(padding: EdgeInsets.only(right: 16.w),
        child: GestureDetector(
             onTap: () {
                      debugPrint('Tapped on provider: ${provider.userName}');
                      Get.to(() => ProfessionalDetailsScreen(
                        professionalId: provider.id,
                      ));
               },
               child: ProfessionalCardWidget(

                 name: provider.serviceTitle, // service_title
                      professional: provider.userName, // user_name
                      rating: double.tryParse(provider.providerRating) ?? 0.0, // provider_rating কে double এ convert করছি
                      price: '\$${provider.providerServiceCharge}/hour',
                      experience: provider.providerExperience, // provider_experience
                      workDone: provider.providerDoneWork, // provider_done_work
                      image: provider.userImage ?? '',
                        onBookNow: () {
                        // Call the API to create conversation and navigate to chat
                        _handleBookNow(provider.userId, provider.userName);
                      }, // user_image - null হলে empty string দিচ্ছি

               ),
        ),
        
        
        );

       }),
       

       );
        }),
      ],
    );
  }
}
