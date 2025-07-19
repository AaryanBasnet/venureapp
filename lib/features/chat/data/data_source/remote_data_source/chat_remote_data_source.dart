import 'package:venure/features/chat/data/model/chat_model.dart';
import 'package:venure/features/chat/data/data_source/remote_data_source/chat_api_service.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ChatModel>> getUserChats({String? venueId});
  Future<ChatModel> getOrCreateChat({
    required String participantId,
    required String venueId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatApiService chatApiService;

  ChatRemoteDataSourceImpl({required this.chatApiService});

  @override
  Future<List<ChatModel>> getUserChats({String? venueId}) async {
    final response = await chatApiService.getUserChats(venueId: venueId);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Future<ChatModel> getOrCreateChat({
    required String participantId,
    required String venueId,
  }) async {
    final response = await chatApiService.getOrCreateChat(
      participantId: participantId,
      venueId: venueId,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChatModel.fromJson(response.data);
    } else {
      throw Exception('Failed to get or create chat');
    }
  }
}
