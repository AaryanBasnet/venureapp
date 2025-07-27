import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/notification/presentation/view_model/notification_event.dart';
import 'package:venure/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:venure/features/notification/presentation/view/notification_widget.dart'; // import your NotificationWidget screen

class HeaderTopRow extends StatelessWidget {
  const HeaderTopRow({super.key, required this.pearlWhite});

  final Color pearlWhite;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Discover Premium Venues",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: pearlWhite.withOpacity(0.9),
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider(
                      create:
                          (_) =>
                              serviceLocator<NotificationViewModel>()
                                ..add(FetchNotifications()),
                      child: const NotificationWidget(),
                    ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: pearlWhite,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
