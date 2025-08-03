import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Import your actual project files
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/notification/domain/entity/notification_entity.dart';
import 'package:venure/features/notification/domain/use_case/get_notification.dart';
import 'package:venure/features/notification/domain/use_case/mark_all_as_read.dart';
import 'package:venure/features/notification/domain/use_case/mark_as_read.dart';
import 'package:venure/features/notification/presentation/view_model/notification_event.dart';
import 'package:venure/features/notification/presentation/view_model/notification_state.dart';
import 'package:venure/features/notification/presentation/view_model/notification_view_model.dart';

// Mocks for UseCases
class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}

class MockMarkAsReadUseCase extends Mock implements MarkAsReadUseCase {}

class MockMarkAllAsReadUseCase extends Mock implements MarkAllAsReadUseCase {}

void main() {
  late NotificationViewModel notificationViewModel;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkAsReadUseCase mockMarkAsReadUseCase;
  late MockMarkAllAsReadUseCase mockMarkAllAsReadUseCase;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkAsReadUseCase = MockMarkAsReadUseCase();
    mockMarkAllAsReadUseCase = MockMarkAllAsReadUseCase();

    notificationViewModel = NotificationViewModel(
      getNotificationsUseCase: mockGetNotificationsUseCase,
      markAsReadUseCase: mockMarkAsReadUseCase,
      markAllAsReadUseCase: mockMarkAllAsReadUseCase,
    );
  });

  tearDown(() {
    notificationViewModel.close();
  });

  final tNotifications = [
    NotificationEntity(
      id: '1',
      type: 'NEW_BOOKING',
      message: 'You have a new booking for your venue.',
      isRead: false,
      createdAt: DateTime(2023, 10, 26, 10, 0),
    ),
    NotificationEntity(
      id: '2',
      type: 'CANCELLATION',
      message: 'A booking was cancelled.',
      isRead: true,
      createdAt: DateTime(2023, 10, 25, 14, 30),
    ),
  ];

  const tApiFailure = ApiFailure(message: 'Server error');

  test('initial state should be NotificationInitial', () {
    expect(notificationViewModel.state, equals(NotificationInitial()));
  });

  group('FetchNotifications', () {
    blocTest<NotificationViewModel, NotificationState>(
      'emits [NotificationLoading, NotificationLoaded] when fetch succeeds',
      build: () {
        when(() => mockGetNotificationsUseCase()).thenAnswer((_) async => Right(tNotifications));
        return notificationViewModel;
      },
      act: (bloc) => bloc.add(FetchNotifications()),
      expect: () => [
        NotificationLoading(),
        NotificationLoaded(tNotifications),
      ],
      verify: (_) {
        verify(() => mockGetNotificationsUseCase()).called(1);
      },
    );

    blocTest<NotificationViewModel, NotificationState>(
      'emits [NotificationLoading, NotificationError] when fetch fails',
      build: () {
        when(() => mockGetNotificationsUseCase()).thenAnswer((_) async => const Left(tApiFailure));
        return notificationViewModel;
      },
      act: (bloc) => bloc.add(FetchNotifications()),
      expect: () => [
        NotificationLoading(),
        NotificationError(tApiFailure.message),
      ],
      verify: (_) {
        verify(() => mockGetNotificationsUseCase()).called(1);
      },
    );
  });

  group('MarkNotificationAsRead', () {
    const tNotificationId = '1';

    blocTest<NotificationViewModel, NotificationState>(
      'calls MarkAsReadUseCase then triggers FetchNotifications and emits loading & loaded states',
      build: () {
        when(() => mockMarkAsReadUseCase(tNotificationId)).thenAnswer((_) async => const Right(null));
        when(() => mockGetNotificationsUseCase()).thenAnswer((_) async => Right(tNotifications));
        return notificationViewModel;
      },
      act: (bloc) => bloc.add(MarkNotificationAsRead(tNotificationId)),
      expect: () => [
        NotificationLoading(),
        NotificationLoaded(tNotifications),
      ],
      verify: (_) {
        verifyInOrder([
          () => mockMarkAsReadUseCase(tNotificationId),
          () => mockGetNotificationsUseCase(),
        ]);
      },
    );
  });

  group('MarkAllNotificationsAsRead', () {
    blocTest<NotificationViewModel, NotificationState>(
      'calls MarkAllAsReadUseCase then triggers FetchNotifications and emits loading & loaded states',
      build: () {
        when(() => mockMarkAllAsReadUseCase()).thenAnswer((_) async => const Right(null));
        when(() => mockGetNotificationsUseCase()).thenAnswer((_) async => Right(tNotifications));
        return notificationViewModel;
      },
      act: (bloc) => bloc.add(MarkAllNotificationsAsRead()),
      expect: () => [
        NotificationLoading(),
        NotificationLoaded(tNotifications),
      ],
      verify: (_) {
        verifyInOrder([
          () => mockMarkAllAsReadUseCase(),
          () => mockGetNotificationsUseCase(),
        ]);
      },
    );
  });
}
