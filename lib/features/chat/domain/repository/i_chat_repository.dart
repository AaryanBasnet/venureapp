import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';

abstract class IChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getUserChats({
    String? venueId,
    required String currentUserId, // added
  });

  Future<Either<Failure, ChatEntity>> getOrCreateChat({
    required String participantId,
    required String venueId,
    required String currentUserId, // added
  });

  Future<Either<Failure, List<MessageEntity>>> getMessagesForChat(String chatId);
}