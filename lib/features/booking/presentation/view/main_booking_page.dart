import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/utils/secure_action_handler.dart';
import 'package:venure/features/booking/presentation/view_model/booking_event.dart';
import 'package:venure/features/booking/presentation/view_model/booking_state.dart';
import 'package:venure/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';

import 'booking_details_page.dart';
import 'addons_page.dart';
import 'payment_page.dart';

class MainBookingPage extends StatelessWidget {
  final String venueName;
  final String venueId; // ✅ Venue ID passed to this page
  final Function(Map<String, dynamic>) onSubmit;

  const MainBookingPage({
    Key? key,
    required this.venueName,
    required this.venueId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              serviceLocator<BookingViewModel>()..add(
                BookingInit({
                  'venue': venueId, // ✅ Preload venue ID into formData
                }),
              ),
      child: Scaffold(
        appBar: AppBar(title: Text('Book Venue: $venueName')),
        body: BlocConsumer<BookingViewModel, BookingState>(
          listener: (context, state) {
            if (state.isSuccess) {
              print(state.formData);

              onSubmit(state.formData);
              context.read<BookingViewModel>().add(BookingReset());
              Navigator.pop(
                context,
              ); // Optional: Pop the booking page after success
            }

            if (state.errorMessage.isNotEmpty) {
              // Show error message if any
              print('[DEBUG] Booking error: ${state.errorMessage}');
              print(state.formData);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            switch (state.currentStep) {
              case 0:
                return BookingDetailsPage(
                  initialData: state.formData,
                  onNext:
                      (data) => context.read<BookingViewModel>().add(
                        BookingNext(data),
                      ),
                );
              case 1:
                return AddonsPage(
                  initialAddons: List<Map<String, dynamic>>.from(
                    state.formData['selectedAddons'] ?? [],
                  ),
                  onNext:
                      (data) => context.read<BookingViewModel>().add(
                        BookingNext(data),
                      ),
                  onBack:
                      () => context.read<BookingViewModel>().add(BookingBack()),
                );
              case 2:
                return PaymentPage(
                  initialData: state.formData,
                  onNext:
                      (data) => context.read<BookingViewModel>().add(
                        BookingNext(data),
                      ),
                  onBack:
                      () => context.read<BookingViewModel>().add(BookingBack()),
                  onSubmit: () async {
                    final isVerified = await SecureActionHandler.verify(
                      context,
                      reason: 'Please confirm your identity to submit booking',
                    );

                    if (isVerified) {
                      context.read<BookingViewModel>().add(BookingSubmit());
                    }
                  },
                );

              default:
                return const Center(child: Text('Unknown step'));
            }
          },
        ),
      ),
    );
  }
}
