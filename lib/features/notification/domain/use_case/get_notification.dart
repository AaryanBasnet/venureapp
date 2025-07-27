import 'package:dartz/dartz.dart';

import 'package:venure/core/error/failure.dart';

import '../entity/notification_entity.dart';
import '../repository/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
