import 'package:hive/hive.dart';
import 'package:venure/features/chat/data/model/chat_model.dart';
import 'package:venure/features/chat/data/model/message_model.dart';

abstract interface class ChatLocalDataSource {
  Future<List<ChatModel>> getCachedChats();
  Future<void> cacheChats(List<ChatModel> chats);
  Future<void> clearCache();

  // New message cache APIs
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<List<MessageModel>> getMessagesForChat(String chatId);

  // Append single message efficiently
  Future<void> cacheMessage(String chatId, MessageModel message);
}
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _chatBoxName = 'chatBox';
  static const String _messageBoxPrefix = 'messageBox_';

  late final Box<ChatModel> _chatBox;
  final Map<String, Box<MessageModel>> _messageBoxes = {};

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      if (!Hive.isAdapterRegistered(ChatModelAdapter().typeId)) {
        Hive.registerAdapter(ChatModelAdapter());
      }
      if (!Hive.isAdapterRegistered(MessageModelAdapter().typeId)) {
        Hive.registerAdapter(MessageModelAdapter());
      }
      _chatBox = await Hive.openBox<ChatModel>(_chatBoxName);
      _initialized = true;
    }
  }

  Future<Box<MessageModel>> _openMessageBox(String chatId) async {
    if (_messageBoxes.containsKey(chatId)) {
      if (Hive.isBoxOpen('$_messageBoxPrefix$chatId')) {
        return _messageBoxes[chatId]!;
      }
    }
    final box = await Hive.openBox<MessageModel>('$_messageBoxPrefix$chatId');
    _messageBoxes[chatId] = box;
    return box;
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    await _ensureInitialized();
    return _chatBox.values.toList();
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    await _ensureInitialized();
    await _chatBox.clear();
    final chatMap = {for (var c in chats) c.id: c};
    await _chatBox.putAll(chatMap);
  }

  @override
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _chatBox.clear();
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized || !Hive.isBoxOpen(_chatBoxName)) {
      await init();
    }
  }

  // Messages caching

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final box = await _openMessageBox(chatId);
    await box.clear();
    final messageMap = {for (var i = 0; i < messages.length; i++) i: messages[i]};
    await box.putAll(messageMap);
  }

  @override
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final box = await _openMessageBox(chatId);
    return box.values.toList();
  }

  @override
  Future<void> cacheMessage(String chatId, MessageModel message) async {
    final box = await _openMessageBox(chatId);
    // Use message id as key for uniqueness (better than index)
    await box.put(message.id, message);
  }
}
