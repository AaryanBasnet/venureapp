import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/notification/domain/use_case/get_notification.dart';
import 'package:venure/features/notification/domain/use_case/mark_all_as_read.dart';
import 'package:venure/features/notification/domain/use_case/mark_as_read.dart';
import 'package:venure/features/notification/presentation/view_model/notification_event.dart';
import 'package:venure/features/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;

  NotificationViewModel({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      final result = await getNotificationsUseCase();
      result.fold(
        (failure) => emit(NotificationError(failure.message)),
        (notifications) => emit(NotificationLoaded(notifications)),
      );
    });

    on<MarkNotificationAsRead>((event, emit) async {
      await markAsReadUseCase(event.id);
      add(FetchNotifications());
    });

    on<MarkAllNotificationsAsRead>((event, emit) async {
      await markAllAsReadUseCase();
      add(FetchNotifications());
    });
  }
}
