import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/booking/domain/use_case/create_booking_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import 'package:venure/features/booking/domain/entity/booking.dart';

class BookingViewModel extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final LocalStorageService localStorage;

  BookingViewModel({
    required this.createBookingUseCase,
    required this.localStorage,
  }) : super(const BookingState()) {
    on<BookingNext>(_onNext);
    on<BookingBack>(_onBack);
    on<BookingReset>(_onReset);
    on<BookingSubmit>(_onSubmit);
  }

  void _onNext(BookingNext event, Emitter<BookingState> emit) {
    final updatedData = Map<String, dynamic>.from(state.formData);
    updatedData.addAll(event.data);

    final nextStep = state.currentStep + 1;

    emit(
      state.copyWith(
        currentStep: nextStep > 2 ? 2 : nextStep,
        formData: updatedData,
      ),
    );
  }

  void _onBack(BookingBack event, Emitter<BookingState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onReset(BookingReset event, Emitter<BookingState> emit) {
    emit(const BookingState());
  }

  Future<void> _onSubmit(BookingSubmit event, Emitter<BookingState> emit) async {
    final userId = localStorage.userId;
    if (userId == null || userId.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User not logged in',
        isSuccess: false,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    try {
      final data = state.formData;

      DateTime? bookingDate;
      try {
        bookingDate = DateTime.parse(data['bookingDate']);
      } catch (_) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid booking date format',
          isSuccess: false,
        ));
        return;
      }

      final booking = Booking(
        id: '',
        venue: data['venue'], // Ensure venueId is here
        bookingDate: bookingDate,
        timeSlot: data['timeSlot'],
        hoursBooked: data['hoursBooked'],
        numberOfGuests: data['numberOfGuests'],
        eventType: data['eventType'],
        specialRequirements: data['specialRequirements'] ?? '',
        contactName: data['contactName'],
        phoneNumber: data['phoneNumber'],
        totalPrice: data['totalPrice'] ?? 0,
        selectedAddons: (data['selectedAddons'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [],
        paymentDetails: Map<String, dynamic>.from(data['paymentDetails'] ?? {}),
        status: 'booked',
        customer: userId,
      );

      final result = await createBookingUseCase(booking);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isSuccess: false,
        )),
        (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
