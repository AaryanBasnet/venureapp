import 'package:dartz/dartz.dart';
import '../entity/notification_entity.dart';
import 'package:venure/core/error/failure.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
}
