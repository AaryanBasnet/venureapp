import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/notification/data/data_source/remote_data_source/notification_api_service.dart';
import 'package:venure/features/notification/data/model/notification_model.dart';
import 'package:venure/features/notification/domain/entity/notification_entity.dart';
import 'package:venure/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApiService service;

  NotificationRepositoryImpl(this.service);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final res = await service.getNotifications();
      final notifications =
          (res.data as List)
              .map((e) => NotificationModel.fromJson(e).toEntity())
              .toList();
      return Right(notifications);
    } catch (e) {
      return Left(ApiFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await service.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: '${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await service.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: '${e.toString()}'));
    }
  }
}
