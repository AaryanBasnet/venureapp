import 'package:hive/hive.dart';
import 'package:venure/features/chat/data/model/chat_model.dart';

abstract interface class ChatLocalDataSource {
  Future<List<ChatModel>> getCachedChats();
  Future<void> cacheChats(List<ChatModel> chats);
  Future<void> clearCache();
}
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _chatBoxName = 'chatBox';

  late final Box<ChatModel> _chatBox;

  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      if (!Hive.isAdapterRegistered(ChatModelAdapter().typeId)) {
        Hive.registerAdapter(ChatModelAdapter());
      }
      _chatBox = await Hive.openBox<ChatModel>(_chatBoxName);
      _initialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized || !Hive.isBoxOpen(_chatBoxName)) {
      await init();
    }
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    try {
      await _ensureInitialized();
      return _chatBox.values.toList();
    } catch (e, st) {
      // Consider logging here
      rethrow; // or return [];
    }
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    try {
      await _ensureInitialized();
      await _chatBox.clear();
      final Map<String, ChatModel> chatMap = {
        for (var chat in chats) chat.id: chat,
      };
      await _chatBox.putAll(chatMap);
    } catch (e, st) {
      // Consider logging
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _ensureInitialized();
      await _chatBox.clear();
    } catch (e, st) {
      // Consider logging
      rethrow;
    }
  }
}
