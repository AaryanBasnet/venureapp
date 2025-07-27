import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/notification/domain/repository/notification_repository.dart';

class MarkAllAsReadUseCase implements UseCaseWithoutParams<void> {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() {
    // Just forward the call, repository handles errors & returns Either
    return repository.markAllAsRead();
  }
}
