import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  String? _currentUrl;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _pingInterval = Duration(seconds: 30);

  // Streams
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  bool get isConnected => _isConnected;

  /// Connect to WebSocket
  /// url: wss://6zpmb4x8-8009.inc1.devtunnels.ms/ws/chat/{conversation_id}/?token={access_token}
  void connect(String url) {
    debugPrint('🔌 WebSocket: Attempting to connect to $url');

    _currentUrl = url;

    try {
      // Close existing connection if any
      disconnect();

      // Parse and validate the URL
      Uri uri = Uri.parse(url);
      
      // Ensure WebSocket scheme (ws:// or wss://)
      if (uri.scheme == 'http') {
        uri = uri.replace(scheme: 'ws');
      } else if (uri.scheme == 'https') {
        uri = uri.replace(scheme: 'wss');
      } else if (uri.scheme != 'ws' && uri.scheme != 'wss') {
        throw Exception('Invalid WebSocket URL scheme: ${uri.scheme}');
      }
      
      // Remove fragment if present
      if (uri.hasFragment) {
        uri = uri.removeFragment();
      }
      
      // Ensure valid port (remove :0 if present)
      if (uri.hasPort && uri.port == 0) {
        uri = uri.replace(port: uri.scheme == 'wss' ? 443 : 80);
      }
      
      final cleanUrl = uri.toString();
      debugPrint('🔌 WebSocket: Clean URL: $cleanUrl');

      // Create WebSocket connection
      _channel = WebSocketChannel.connect(uri);

      // Listen to messages
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController.add(true);
      debugPrint('✅ WebSocket: Connected successfully');

      // Start ping to keep connection alive
      _startPingTimer();
    } catch (e) {
      debugPrint('❌ WebSocket: Connection error: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
      _scheduleReconnect();
    }
  }

  /// Handle incoming messages
  void _onMessage(dynamic message) {
    try {
      debugPrint('📩 WebSocket: Received message: $message');

      final data = jsonDecode(message);
      _messageController.add(data);
    } catch (e) {
      debugPrint('❌ WebSocket: Error parsing message: $e');
    }
  }

  /// Handle errors
  void _onError(error) {
    debugPrint('❌ WebSocket: Error occurred: $error');
    _isConnected = false;
    _connectionStatusController.add(false);
    _scheduleReconnect();
  }

  /// Handle connection close
  void _onDone() {
    debugPrint('⚠️ WebSocket: Connection closed');
    _isConnected = false;
    _connectionStatusController.add(false);
    _scheduleReconnect();
  }

  /// Send message through WebSocket
  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) {
      debugPrint('❌ WebSocket: Cannot send message - not connected');
      return;
    }

    try {
      final jsonMessage = jsonEncode(message);
      _channel!.sink.add(jsonMessage);
      debugPrint('📤 WebSocket: Message sent: $jsonMessage');
    } catch (e) {
      debugPrint('❌ WebSocket: Error sending message: $e');
    }
  }

  /// Schedule reconnection
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('❌ WebSocket: Max reconnection attempts reached');
      return;
    }

    if (_reconnectTimer?.isActive ?? false) {
      return;
    }

    _reconnectAttempts++;
    debugPrint(
      '🔄 WebSocket: Scheduling reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${_reconnectDelay.inSeconds}s',
    );

    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_currentUrl != null) {
        connect(_currentUrl!);
      }
    });
  }

  /// Start ping timer to keep connection alive
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (timer) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'ping'}));
          debugPrint('🏓 WebSocket: Ping sent');
        } catch (e) {
          debugPrint('❌ WebSocket: Error sending ping: $e');
        }
      }
    });
  }

  /// Disconnect from WebSocket
  void disconnect() {
    debugPrint('🔌 WebSocket: Disconnecting...');

    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close(status.normalClosure);

    _isConnected = false;
    _connectionStatusController.add(false);
    _reconnectAttempts = 0;

    debugPrint('✅ WebSocket: Disconnected');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionStatusController.close();
  }
}
