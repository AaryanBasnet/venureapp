import 'package:equatable/equatable.dart';

class BookingState extends Equatable {
  final int currentStep;
  final Map<String, dynamic> formData;
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  const BookingState({
    this.currentStep = 0,
    this.formData = const {'selectedAddons': <Map<String, dynamic>>[]},
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  BookingState copyWith({
    int? currentStep,
    Map<String, dynamic>? formData,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      formData: formData ?? this.formData,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [currentStep, formData, isLoading, isSuccess, errorMessage];
}
