import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/notification/domain/repository/notification_repository.dart';

class MarkAsReadUseCase implements UseCaseWithParams<void, String> {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.markAsRead(id);
  }
}
