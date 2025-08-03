import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/utils/secure_action_handler.dart';
import 'package:venure/features/booking/presentation/view_model/booking_event.dart';
import 'package:venure/features/booking/presentation/view_model/booking_state.dart';
import 'package:venure/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/common/presentation/view/venure_main_screen.dart';


import 'booking_details_page.dart';
import 'addons_page.dart';
import 'payment_page.dart';

class MainBookingPage extends StatelessWidget {
  final String venueName;
  final String venueId;
  final int pricePerHour;
  final Function(Map<String, dynamic>) onSubmit;

  const MainBookingPage({
    super.key,
    required this.venueName,
    required this.venueId,
    required this.onSubmit,
    required this.pricePerHour,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              serviceLocator<BookingViewModel>()..add(
                BookingInit({
                  'venue': venueId,
                  'pricePerHour': pricePerHour, // Include this
                }),
              ),

      child: Scaffold(
        appBar: AppBar(title: Text('Book Venue: $venueName')),
        body: BlocConsumer<BookingViewModel, BookingState>(
          listenWhen:
              (previous, current) =>
                  previous.paymentStatus != current.paymentStatus ||
                  previous.isSuccess != current.isSuccess ||
                  previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.paymentStatus == PaymentStatus.success &&
                !state.hasSubmitted) {
              context.read<BookingViewModel>().add(BookingSubmit());
            }

            if (state.isSuccess) {
              onSubmit(state.formData);
              context.read<BookingViewModel>().add(BookingReset());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const VenureMainScreen()),
                (route) => false,
              );
            }
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
            if (state.paymentStatus == PaymentStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment failed: ${state.paymentError}'),
                ),
              );
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
                      context.read<BookingViewModel>().add(
                        BookingStartPayment(),
                      );
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
