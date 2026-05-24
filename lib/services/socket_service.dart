import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api.dart';
import 'api_service.dart';

class SocketService {
  static IO.Socket? _socket;
  static bool _connected = false;

  static Future<void> connect(String userId) async {
    final token = await ApiService.getToken();
    if (token == null) return;

    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _connected = true;
      _socket!.emit('join', userId);
      print('[Socket] Connected and joined room: user_$userId');
    });

    _socket!.onDisconnect((_) {
      _connected = false;
      print('[Socket] Disconnected');
    });

    _socket!.onConnectError((err) {
      print('[Socket] Connection error: $err');
    });
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _connected = false;
  }

  static bool get isConnected => _connected;

  // ── EMIT ──────────────────────────────────────────────────
  static void sendMessage(String requestId, String senderId,
      String senderName, String text) {
    _socket?.emit('send_message', {
      'requestId': requestId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
    });
  }

  static void joinRoom(String userId) {
    _socket?.emit('join', userId);
  }

  // ── SUBSCRIBE ─────────────────────────────────────────────
  static void onNewMessage(Function(dynamic) callback) {
    _socket?.on('new_message', callback);
  }

  static void onRequestStatusUpdated(Function(dynamic) callback) {
    _socket?.on('request_status_updated', callback);
  }

  static void onQuoteReceived(Function(dynamic) callback) {
    _socket?.on('quote_received', callback);
  }

  static void onJobPendingConfirmation(Function(dynamic) callback) {
    _socket?.on('job_pending_confirmation', callback);
  }

  static void onNotification(Function(dynamic) callback) {
    _socket?.on('notification', callback);
  }

  static void onEscrowReleased(Function(dynamic) callback) {
    _socket?.on('escrow_released', callback);
  }

  // ── UNSUBSCRIBE ───────────────────────────────────────────
  static void off(String event) {
    _socket?.off(event);
  }

  static void offAll() {
    _socket?.offAny();
  }
}
