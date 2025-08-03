// my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';
import 'package:venure/features/profile/presentation/view/my_bookings_view/my_bookings_view.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_booking_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_event.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';

class MyBookingsScreen extends StatelessWidget {
  final GetMyBookingsUseCase getBookingsUseCase;

  const MyBookingsScreen({super.key, required this.getBookingsUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => BookingBloc(
            getBookingsUseCase: getBookingsUseCase,
            cancelBookingUseCase: serviceLocator<CancelBookingUseCase>(),
          )..add(FetchBookings()),
      child: const MyBookingsView(), // ✅ Provide the UI!
    );
  }
}
