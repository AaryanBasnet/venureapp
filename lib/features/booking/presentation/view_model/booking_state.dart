import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, processing, success, failure }
class BookingState extends Equatable {
  final int currentStep;
  final Map<String, dynamic> formData;
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final PaymentStatus paymentStatus;
  final String paymentError;
  final String? paymentIntentId;
  final bool hasSubmitted;

  

  const BookingState({
    this.currentStep = 0,
    this.formData = const {},
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.paymentStatus = PaymentStatus.initial,
    this.paymentError = '',
    this.paymentIntentId,
      this.hasSubmitted = false,
  });

  BookingState copyWith({
    int? currentStep,
    Map<String, dynamic>? formData,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    PaymentStatus? paymentStatus,
    String? paymentError,
    String? paymentIntentId,
     bool? hasSubmitted,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      formData: formData ?? this.formData,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentError: paymentError ?? this.paymentError,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    formData,
    isLoading,
    isSuccess,
    errorMessage,
    paymentStatus,
    paymentError,
    paymentIntentId,
     hasSubmitted,
  ];
}
