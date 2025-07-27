import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/notification/presentation/view_model/notification_event.dart';
import 'package:venure/features/notification/presentation/view_model/notification_state.dart';
import 'package:venure/features/notification/presentation/view_model/notification_view_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = serviceLocator<NotificationViewModel>();
    notificationViewModel.add(FetchNotifications());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined),
            onPressed: () {
              notificationViewModel.add(MarkAllNotificationsAsRead());
            },
            tooltip: 'Mark All as Read',
          ),
        ],
      ),
      body: BlocBuilder<NotificationViewModel, NotificationState>(
        bloc: notificationViewModel,
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('No notifications found.'));
            }

            return ListView.separated(
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return ListTile(
                  title: Text(notification.type),
                  subtitle: Text(notification.message),
                  trailing: notification.isRead
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.mark_email_read),
                          onPressed: () {
                            notificationViewModel.add(
                              MarkNotificationAsRead(notification.id),
                            );
                          },
                          tooltip: 'Mark as Read',
                        ),
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
