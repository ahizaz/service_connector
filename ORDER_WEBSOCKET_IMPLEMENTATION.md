# Order WebSocket Implementation

## Overview
This document describes the implementation of WebSocket-based order notifications in the Service Connect app. When a provider sends an order, it now appears in the receiver's inbox through WebSocket messages in real-time.

## Architecture

### 1. Message Flow
```
Provider Creates Order 
    ↓
CreateOrderController
    ↓
Send REST API Request (Create Order)
    ↓
Get Order Response
    ↓
Send WebSocket Notification
    ↓
ChatController (via WebSocketService)
    ↓
Receiver's Chat Inbox
```

### 2. Components Modified

#### A. Chat Message Model (`lib/feature/chat/model/chat_message_model.dart`)
**Changes:**
- Added `MessageType.order` enum value
- Added `orderDetails` field to `ChatMessage` class
- Created new `OrderDetails` class with fields:
  - `orderId`: The order ID
  - `quotationId`: Associated quotation ID
  - `orderStatus`: Current order status (pending, confirmed, etc.)
  - `serviceTimeTaken`: Time taken for service
  - `serviceCost`: Service cost
  - `serviceTimeline`: Service timeline
  - `serviceDescription`: Optional description

#### B. WebSocket Message Model (`lib/feature/chat/model/websocket_message_model.dart`)
**Changes:**
- Added order-related fields:
  - `orderId`: Order ID (nullable)
  - `orderStatus`: Order status (nullable)
  - `serviceTimeTaken`: Service time (nullable)
- Updated `fromJson` and `toJson` to handle order fields
- Modified `toChatMessage()` method to detect and convert order messages:
  - Checks for `orderId` in the message
  - Creates `OrderDetails` object
  - Sets message type to `MessageType.order`

#### C. Create Order Controller (`lib/feature/order/controller/create_order_controller.dart`)
**Changes:**
- Added imports for `ChatController` and `SharedPreferences`
- Modified `createOrder()` method to:
  - Parse order response to get order details
  - Call `_sendOrderNotification()` after successful order creation
- Added new method `_sendOrderNotification()`:
  - Gets current user info (sender ID and name)
  - Attempts to get `ChatController` instance
  - Checks WebSocket connection status
  - Sends order notification through WebSocket
  - Handles gracefully if WebSocket is not available

**WebSocket Message Format:**
```dart
{
  'type': 'order',
  'message': 'New order created',
  'order_details': {
    'order_id': orderId,
    'quotation_id': quotationId,
    'order_status': orderStatus,
    'service_time_taken': serviceTimeTaken,
  },
  'sender_id': senderId,
  'sender_name': senderName,
  'message_text': '📦 New Order #$orderId has been created',
}
```

#### D. Chat Controller (`lib/feature/chat/controller/chat_controller.dart`)
**Changes:**
- Added `sendWebSocketMessage()` method:
  - Checks WebSocket connection status
  - Sends message through `WebSocketService`
  - Handles errors gracefully
- Updated `fetchAllConversations()`:
  - Added order message display in inbox ('📦 New Order')
  - Added offer message display in inbox ('💼 New Offer')
- The existing `_handleWebSocketMessage()` method already handles order messages through the updated `toChatMessage()` method

#### E. Chat Detail Screen (`lib/feature/chat/screen/chat_detail_screen.dart`)
**Changes:**
- Modified `_buildMessageBubble()`:
  - Added check for `MessageType.order`
  - Calls `_buildOrderMessage()` for order messages
- Added new widget `_buildOrderMessage()`:
  - Displays order notification with green gradient background
  - Shows shopping bag icon
  - Displays order ID, quotation ID, status, and service time
  - Shows sender information and timestamp
- Added helper widget `_buildOrderInfoRow()`:
  - Reusable widget for displaying order information rows
  - Shows icon, label, and value

## UI Design

### Order Message Bubble
The order message appears as a centered card with:
- **Background**: Green gradient (symbolizing new order/success)
- **Icon**: Shopping bag icon in a semi-transparent white circle
- **Header**: "📦 New Order Created" with order number
- **Info Section**: Semi-transparent white container showing:
  - Quotation ID with receipt icon
  - Order status with info icon
  - Service time with clock icon
  - Optional service description
- **Footer**: Timestamp and sender name

### Inbox Display
In the conversation list, order messages appear as:
- **Text**: "📦 New Order"
- **Icon**: Shopping bag emoji for quick visual identification

## Usage Example

### When Provider Creates Order:
1. Provider fills out order form in `CreateOrderScreen`
2. Clicks "Submit Order"
3. `CreateOrderController.createOrder()` is called
4. REST API creates order in backend
5. On success, WebSocket notification is sent
6. Receiver's `ChatController` receives WebSocket message
7. Message is parsed and converted to `ChatMessage` with `MessageType.order`
8. Order appears in receiver's chat inbox immediately
9. Opening the chat shows the order notification card

### Fallback Behavior:
- If WebSocket is not connected, order is still created via REST API
- Receiver will see the order when they:
  - Refresh conversations list
  - Open the chat conversation
  - Connect to WebSocket (will receive pending messages)

## Testing

### To Test Order WebSocket:
1. **Setup**: Ensure both provider and receiver are logged in
2. **Connect**: Have receiver open a chat conversation (WebSocket connects)
3. **Create**: Provider creates an order for that conversation
4. **Verify**: 
   - Check provider sees success message
   - Check receiver's chat updates in real-time
   - Verify order message appears with correct details
   - Check inbox shows "📦 New Order" preview

### Debug Logs:
The implementation includes comprehensive debug prints:
- `CreateOrderController`: Shows order creation and WebSocket sending
- `ChatController`: Shows WebSocket message reception and parsing
- `WebSocketService`: Shows connection status and message transmission

Search for these prefixes in logs:
- `📤 CREATING ORDER`
- `🔌 SENDING ORDER WEBSOCKET NOTIFICATION`
- `📩 WebSocket message received`
- `✅ Message added to chat list`

## Future Enhancements

### Potential Improvements:
1. **Order Status Updates**: Send WebSocket updates when order status changes
2. **Order Tracking**: Add real-time order tracking through WebSocket
3. **Push Notifications**: Integrate with FCM for offline notifications
4. **Order Actions**: Add buttons to view order details, accept/reject
5. **Order History**: Show order history in a dedicated screen
6. **Message Persistence**: Store order messages in local database

## Dependencies

### Required Packages:
- `web_socket_channel`: For WebSocket communication
- `get`: State management and navigation
- `shared_preferences`: Store user session data
- `flutter_screenutil`: Responsive UI sizing
- `http`: REST API calls

## API Requirements

### Backend Support Needed:
- **WebSocket Server**: Must handle `order` type messages
- **Order API**: `/offer/orders/` endpoint for creating orders
- **Message Format**: Backend should broadcast order messages to relevant conversation
- **Field Mapping**: Backend must include `order_id`, `order_status`, `service_time_taken` in messages

## Troubleshooting

### Common Issues:

**Order notification not appearing:**
- Check WebSocket connection status
- Verify `ChatController` is initialized
- Check if receiver has opened the conversation
- Review debug logs for errors

**Message appears but formatting is wrong:**
- Verify `OrderDetails` object has all required fields
- Check if `serviceDescription` is properly formatted
- Ensure backend sends all required fields

**Duplicate messages:**
- The system handles duplicates by checking message IDs
- If duplicates persist, check backend message ID generation

## Code References

### Key Files:
- Message Models: `/lib/feature/chat/model/`
- Controllers: `/lib/feature/order/controller/` and `/lib/feature/chat/controller/`
- UI: `/lib/feature/chat/screen/chat_detail_screen.dart`
- WebSocket Service: `/lib/core/services/websocket_service.dart`

### Related Features:
- Offer creation and notification (similar pattern)
- Chat messaging (uses same WebSocket infrastructure)
- Conversation management (handles message display in inbox)

---

**Implementation Date**: January 15, 2026
**Version**: 1.0
**Author**: Development Team
