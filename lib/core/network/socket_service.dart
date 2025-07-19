import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:venure/features/chat/domain/entity/message_entity.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  late IO.Socket _socket;
  bool _initialized = false;

  Function(MessageEntity)? _messageCallback;

  void initialize({required String userId, required String chatId}) {
    if (_initialized) return;
    _initialized = true;

    _socket = IO.io(
      'http://10.0.2.2:5050',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'chatId': chatId})
          .build(),
    );

    _socket.onConnect((_) {
      print('Socket connected');
      _socket.emit('join', userId);
    });

    // Register listener exactly once outside of onConnect
    _socket.on('receiveMessage', (data) {
      print('Socket received message event: $data');
      try {
        final message = MessageEntity(
          id: data['_id'] ?? '',
          chatId: data['chatId'] ?? '',
          text: data['text'] ?? '',
          senderId: data['sender'] ?? '',
          receiverId: data['receiver'] ?? '',
          timestamp: DateTime.parse(
            data['timestamp'] ?? DateTime.now().toIso8601String(),
          ),
          seen: data['seen'] ?? false,
        );
        if (_messageCallback != null) {
          _messageCallback!(message);
        }
      } catch (e) {
        print('Error parsing message: $e');
      }
    });

    _socket.connect();

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.onConnectError((err) {
      print('Socket connection error: $err');
    });
  }

  void onReceiveMessage(Function(MessageEntity) callback) {
    _messageCallback = callback;
  }

  void sendMessage({
    required String chatId,
    required String sender,
    required String receiver,
    required String text,
  }) {
    final messageData = {
      'chatId': chatId,
      'sender': sender,
      'receiver': receiver,
      'text': text,
    };

    _socket.emit('sendMessage', messageData);
  }

  void dispose() {
    if (!_initialized) return;
    _initialized = false;

    _socket.disconnect();
    _socket.dispose();
  }
}
