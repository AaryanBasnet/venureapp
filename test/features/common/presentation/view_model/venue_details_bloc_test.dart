import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_event.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_state.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class MockVenueRepository extends Mock implements IVenueRepository {}

class TestVenue extends Venue {
  TestVenue({required super.id, required super.venueName})
    : super(
        ownerId: 'owner-$id',
        location: VenueLocation(
          address: 'Addr',
          city: 'City',
          state: 'State',
          country: 'Country',
        ),
        capacity: 100,
        venueImages: [],
        amenities: [],
        pricePerHour: 200,
        status: 'active',
        isDeleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

void main() {
  late MockVenueRepository mockVenueRepository;
  late VenueDetailsBloc bloc;

  const venueId = 'v1';
  final tVenue = TestVenue(id: venueId, venueName: 'Royal Hall');
  const tFailure = ApiFailure(message: 'Not found');

  setUp(() {
    mockVenueRepository = MockVenueRepository();
    bloc = VenueDetailsBloc(venueRepository: mockVenueRepository);
  });

  tearDown(() => bloc.close());

  test('initial state is VenueDetailsInitial', () {
    expect(bloc.state, VenueDetailsInitial());
  });

  blocTest<VenueDetailsBloc, VenueDetailsState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(
        () => mockVenueRepository.getVenueById(venueId),
      ).thenAnswer((_) async => Right(tVenue));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadVenueDetails(venueId)),
    expect: () => [VenueDetailsLoading(), VenueDetailsLoaded(tVenue)],
    verify: (_) {
      verify(() => mockVenueRepository.getVenueById(venueId)).called(1);
    },
  );

  blocTest<VenueDetailsBloc, VenueDetailsState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(
        () => mockVenueRepository.getVenueById(venueId),
      ).thenAnswer((_) async => const Left(tFailure));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadVenueDetails(venueId)),
    expect:
        () => [
          VenueDetailsLoading(),
          VenueDetailsError(tFailure.message ?? 'Unexpected error'),
        ],
    verify: (_) {
      verify(() => mockVenueRepository.getVenueById(venueId)).called(1);
    },
  );
}
