import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';

class GetUserChatsUseCase implements UseCaseWithParams<List<ChatEntity>, Map<String, String?>> {
  final IChatRepository repository;

  GetUserChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(Map<String, String?> params) {
    final venueId = params['venueId'];
    final currentUserId = params['currentUserId'];
    if (currentUserId == null || currentUserId.isEmpty) {
      throw ArgumentError('currentUserId is required and cannot be empty');
    }

    return repository.getUserChats(
      venueId: venueId,
      currentUserId: currentUserId,
    );
  }
}
