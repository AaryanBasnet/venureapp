import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/core/network/api_service.dart';
import 'package:venure/features/chat/data/data_source/local_data_source/chat_local_data_source.dart';
import 'package:venure/features/chat/data/data_source/remote_data_source/chat_remote_data_source.dart';
import 'package:venure/features/chat/data/model/chat_model.dart';
import 'package:venure/features/chat/data/model/message_model.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';

class ChatRepositoryImpl implements IChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final ApiService apiService;

  ChatRepositoryImpl({
    required this.apiService,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ChatEntity>>> getUserChats({
    String? venueId,
    required String currentUserId,
  }) async {
    try {
      final List<ChatModel> remoteChats = await remoteDataSource.getUserChats(
        venueId: venueId,
      );
      await localDataSource.cacheChats(remoteChats);

      // Convert models to entities passing currentUserId
      final chats =
          remoteChats
              .map((model) => model.toEntity(currentUserId: currentUserId))
              .toList();

      return Right(chats);
    } catch (e) {
      try {
        final cachedChats = await localDataSource.getCachedChats();
        if (cachedChats.isNotEmpty) {
          final chats =
              cachedChats
                  .map((model) => model.toEntity(currentUserId: currentUserId))
                  .toList();
          return Right(chats);
        }
      } catch (_) {}
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getOrCreateChat({
    required String participantId,
    required String venueId,
    required String currentUserId,
  }) async {
    try {
      final ChatModel chat = await remoteDataSource.getOrCreateChat(
        participantId: participantId,
        venueId: venueId,
      );
      await localDataSource.cacheChats([chat]);

      // Convert model to entity passing currentUserId
      return Right(chat.toEntity(currentUserId: currentUserId));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // New method to save a message locally
  Future<void> saveMessageLocally(MessageEntity message) async {
    final msgModel = MessageModel(
      id: message.id,
      chatId: message.chatId,
      senderId: message.senderId,
      receiverId: message.receiverId,
      text: message.text,
      timestamp: message.timestamp,
      seen: message.seen,
    );
    await localDataSource.cacheMessage(message.chatId, msgModel);
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessagesForChat(
    String chatId,
  ) async {
    try {
      final localStorage = await LocalStorageService.getInstance();
      final token = localStorage.token;

      final response = await apiService.dio.get(
        ApiEndpoints.getMessages(chatId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Left(ApiFailure(message: 'Failed to load messages'));
      }

      final data = response.data as List;
      final messages =
          data.map((json) => MessageModel.fromJson(json).toEntity()).toList();

      // Cache messages locally after remote fetch
      await localDataSource.cacheMessages(
        chatId,
        data.map((json) => MessageModel.fromJson(json)).toList(),
      );

      return Right(messages);
    } catch (e) {
      // Fallback to local cache on error
      try {
        final cachedMessages = await localDataSource.getMessagesForChat(chatId);
        if (cachedMessages.isNotEmpty) {
          return Right(cachedMessages.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}

      return Left(ApiFailure(message: e.toString()));
    }
  }
}
