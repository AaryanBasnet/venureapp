import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import 'package:venure/core/network/payment_service.dart';
import 'package:venure/features/booking/domain/use_case/create_booking_usecase.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/booking/domain/entity/booking.dart';

class BookingViewModel extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final LocalStorageService localStorage;
  final PaymentService _paymentService = PaymentService();

  BookingViewModel({
    required this.createBookingUseCase,
    required this.localStorage,
  }) : super(const BookingState()) {
    on<BookingInit>(_onInit);
    on<BookingNext>(_onNext);
    on<BookingBack>(_onBack);
    on<BookingReset>(_onReset);
    on<BookingStartPayment>(_onStartPayment);
    on<BookingSubmit>(_onSubmit);
  }

  void _onInit(BookingInit event, Emitter<BookingState> emit) {
    emit(state.copyWith(formData: event.initialData));
  }

  void _onNext(BookingNext event, Emitter<BookingState> emit) {
    final updatedData = Map<String, dynamic>.from(state.formData);
    updatedData.addAll(event.data);

    // Calculate total price if we have enough info
    final pricePerHour = updatedData['pricePerHour'] ?? 0;
    final hours = updatedData['hoursBooked'] ?? 0;
    final guests = updatedData['numberOfGuests'] ?? 0;
    int basePrice = pricePerHour * hours;

    int addonsPrice = 0;
    final addons = updatedData['selectedAddons'] as List<Map<String, dynamic>>?;
    if (addons != null) {
      for (var addon in addons) {
        final price = addon['price'] ?? 0;
        final perPerson = addon['perPerson'] ?? false;
        addonsPrice +=
            perPerson ? (price * guests as int).toInt() : (price as int);
      }
    }

    updatedData['totalPrice'] = basePrice + addonsPrice;

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

  Future<void> _onStartPayment(
    BookingStartPayment event,
    Emitter<BookingState> emit,
  ) async {
    emit(
      state.copyWith(paymentStatus: PaymentStatus.processing, paymentError: ''),
    );

    try {
      final data = state.formData;
      final int totalPrice = data['totalPrice'] ?? 0;
      final String venueId = data['venue'];
      final String bookingDate = data['bookingDate'];
      final String timeSlot = data['timeSlot'];

      final localStorage = await LocalStorageService.getInstance();
      final token = localStorage.token;

      if (token == null) {
        emit(
          state.copyWith(
            paymentStatus: PaymentStatus.failure,
            paymentError: 'User token not found',
          ),
        );
        return;
      }

      // 🔁 1. Get both clientSecret & paymentIntentId from backend
      final result = await _paymentService.createPaymentIntent(
        amount: totalPrice,
        venueId: venueId,
        bookingDate: bookingDate,
        timeSlot: timeSlot,
        token: token,
      );

      final String clientSecret = result['clientSecret'];
      final String paymentIntentId = result['paymentIntentId'];

      // 🔁 2. Save paymentIntentId in state
      emit(state.copyWith(paymentIntentId: paymentIntentId));

      // 🔁 3. Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Venue',
        ),
      );

      // 🔁 4. Present payment sheet to user
      await Stripe.instance.presentPaymentSheet();

      // 🔁 5. Update payment status to success
      emit(state.copyWith(paymentStatus: PaymentStatus.success));
    } on StripeException catch (e) {
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.failure,
          paymentError: e.error.localizedMessage ?? 'Payment failed',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.failure,
          paymentError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSubmit(
    BookingSubmit event,
    Emitter<BookingState> emit,
  ) async {
    final userId = localStorage.userId;
    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'User not logged in',
          isSuccess: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    try {
      final data = state.formData;

      DateTime? bookingDate;
      try {
        bookingDate = DateTime.parse(data['bookingDate']);
      } catch (_) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid booking date format',
            isSuccess: false,
          ),
        );
        return;
      }

      final booking = Booking(
        id: '',
        venue: data['venue'],
        bookingDate: bookingDate,
        timeSlot: data['timeSlot'],
        hoursBooked: data['hoursBooked'],
        numberOfGuests: data['numberOfGuests'],
        eventType: data['eventType'],
        specialRequirements: data['specialRequirements'] ?? '',
        contactName: data['contactName'],
        phoneNumber: data['phoneNumber'],
        totalPrice: data['totalPrice'] ?? 0,
        selectedAddons:
            (data['selectedAddons'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [],
        paymentDetails: {'paymentIntentId': state.paymentIntentId},
        status: 'booked',
        customer: userId,
      );

      final result = await createBookingUseCase(booking);

      result.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            isSuccess: false,
            hasSubmitted: false,
          ),
        ),
        (_) => emit(
          state.copyWith(isLoading: false, isSuccess: true, hasSubmitted: true),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
