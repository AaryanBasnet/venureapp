import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';
import 'venue_details_event.dart';
import 'venue_details_state.dart';

class VenueDetailsBloc extends Bloc<VenueDetailsEvent, VenueDetailsState> {
  final IVenueRepository venueRepository;

  VenueDetailsBloc({required this.venueRepository}) : super(VenueDetailsInitial()) {
    on<LoadVenueDetails>((event, emit) async {
      emit(VenueDetailsLoading());
      final result = await venueRepository.getVenueById(event.venueId);
      result.fold(
        (failure) => emit(VenueDetailsError(_mapFailureToMessage(failure))),
        (venue) => emit(VenueDetailsLoaded(venue)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Map different failure types to user-friendly strings here
    return failure.message ?? "Unexpected error";
  }
}
