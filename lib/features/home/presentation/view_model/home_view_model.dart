import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/home/domain/use_case/get_all_venues_use_case.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetAllVenuesUseCase getAllVenuesUseCase;

  HomeScreenBloc({required this.getAllVenuesUseCase}) : super(HomeScreenInitial()) {
    on<LoadVenues>(_onLoadVenues);
  }

  Future<void> _onLoadVenues(
      LoadVenues event,
      Emitter<HomeScreenState> emit,
  ) async {
    emit(HomeScreenLoading());
    try {
      final result = await getAllVenuesUseCase();
      result.fold(
        (failure) => emit(HomeScreenError(failure.toString())),
        (venues) => emit(HomeScreenLoaded(venues)),
      );
    } catch (e) {
      emit(HomeScreenError(e.toString()));
    }
  }
}