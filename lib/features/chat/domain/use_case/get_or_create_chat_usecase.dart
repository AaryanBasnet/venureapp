import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';

// Base params without currentUserId (could be used elsewhere if needed)
class GetOrCreateChatParams {
  final String participantId;
  final String venueId;

  GetOrCreateChatParams({
    required this.participantId,
    required this.venueId,
  });
}

// Params including currentUserId, extending the base params
class GetOrCreateChatParamsWithUser extends GetOrCreateChatParams {
  final String currentUserId;

  GetOrCreateChatParamsWithUser({
    required String participantId,
    required String venueId,
    required this.currentUserId,
  }) : super(participantId: participantId, venueId: venueId);
}

// Use case requiring currentUserId (so using the extended params)
class GetOrCreateChatUseCase
    implements UseCaseWithParams<ChatEntity, GetOrCreateChatParamsWithUser> {
  final IChatRepository repository;

  GetOrCreateChatUseCase(this.repository);

  @override
  Future<Either<Failure, ChatEntity>> call(
    GetOrCreateChatParamsWithUser params,
  ) {
    return repository.getOrCreateChat(
      participantId: params.participantId,
      venueId: params.venueId,
      currentUserId: params.currentUserId,
    );
  }
}
