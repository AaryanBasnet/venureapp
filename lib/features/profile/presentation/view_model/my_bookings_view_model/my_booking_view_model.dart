import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_event.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetMyBookingsUseCase getBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingBloc({
    required this.getBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
    on<CancelBooking>(_onCancelBooking);
  }

  Future<void> _onFetchBookings(
    FetchBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await getBookingsUseCase();
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingLoaded(bookings)),
    );
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<BookingState> emit,
  ) async {
    final currentState = state;

    if (currentState is BookingLoaded) {
      final currentBookings = currentState.bookings;
      final updatedBookings =
          currentBookings.where((b) => b.id != event.bookingId).toList();

      emit(BookingLoaded(updatedBookings)); // No loading spinner, smooth update

      // Call the cancel API
      final result = await cancelBookingUseCase(event.bookingId);

      result.fold(
        (failure) {
          // Rollback in case of failure (optional)
          emit(BookingError(failure.message));
        },
        (success) {
          // Optionally: Re-fetch from backend to stay safe
          add(FetchBookings());
        },
      );
    }
  }
}
