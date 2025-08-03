import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/app/service_locator/service_locator.dart' as di;
import 'package:venure/features/notification/domain/entity/notification_entity.dart';
import 'package:venure/features/notification/presentation/view/notification_widget.dart';
import 'package:venure/features/notification/presentation/view_model/notification_event.dart';
import 'package:venure/features/notification/presentation/view_model/notification_state.dart';
import 'package:venure/features/notification/presentation/view_model/notification_view_model.dart';

// --- Mock ---
class MockNotificationViewModel extends Mock implements NotificationViewModel {}

// --- Fakes ---
class FakeNotificationEvent extends Fake implements NotificationEvent {}
class FakeNotificationState extends Fake implements NotificationState {}

void main() {
  late MockNotificationViewModel mockNotificationViewModel;

  setUp(() {
    registerFallbackValue(FakeNotificationEvent());
    registerFallbackValue(FakeNotificationState());

    // CHANGE 1: Allow GetIt to override registrations for testing.
    di.serviceLocator.allowReassignment = true;

    mockNotificationViewModel = MockNotificationViewModel();
    di.serviceLocator.registerLazySingleton<NotificationViewModel>(
      () => mockNotificationViewModel,
    );
  });
  
  // It's good practice to reset GetIt after tests
  tearDown(() {
    di.serviceLocator.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: NotificationWidget(),
    );
  }

  void stubViewModelState(NotificationState state) {
    when(() => mockNotificationViewModel.state).thenReturn(state);
    when(() => mockNotificationViewModel.stream).thenAnswer((_) => Stream.value(state));
    when(() => mockNotificationViewModel.add(any())).thenReturn(null);
  }

  testWidgets('dispatches FetchNotifications on build', (tester) async {
    // Arrange
    stubViewModelState(NotificationLoading());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    // CHANGE 2: Use a type matcher for a more robust verification.
    verify(() => mockNotificationViewModel.add(any(that: isA<FetchNotifications>()))).called(1);
  });

  testWidgets('shows loading indicator when loading', (tester) async {
    // Arrange
    stubViewModelState(NotificationLoading());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty message when no notifications', (tester) async {
    // Arrange
    stubViewModelState(NotificationLoaded(const []));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('No notifications found.'), findsOneWidget);
  });

  testWidgets('shows list of notifications when loaded', (tester) async {
    // Arrange
    final notifications = [
      NotificationEntity(id: '1', type: 'Type A', message: 'Message A', isRead: false, createdAt: DateTime.now()),
      NotificationEntity(id: '2', type: 'Type B', message: 'Message B', isRead: true, createdAt: DateTime.now()),
    ];
    stubViewModelState(NotificationLoaded(notifications));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('Type A'), findsOneWidget);
    expect(find.text('Message A'), findsOneWidget);
    expect(find.byIcon(Icons.mark_email_read), findsOneWidget);
  });

  testWidgets('tapping "Mark All as Read" triggers event', (tester) async {
    // Arrange
    stubViewModelState(NotificationLoaded(const []));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.byTooltip('Mark All as Read'));

    // Assert
    verify(() => mockNotificationViewModel.add(any(that: isA<MarkAllNotificationsAsRead>()))).called(1);
  });

  testWidgets('tapping "Mark as Read" triggers event', (tester) async {
    // Arrange
    final notifications = [
      NotificationEntity(id: '1', type: 'Type A', message: 'Message A', isRead: false, createdAt: DateTime.now()),
    ];
    stubViewModelState(NotificationLoaded(notifications));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.byTooltip('Mark as Read'));

    // Assert
    verify(() => mockNotificationViewModel.add(any(that: isA<MarkNotificationAsRead>())))
        .called(1);
  });

  testWidgets('shows error message when error state', (tester) async {
    // Arrange
    stubViewModelState(const NotificationError('Failed to load'));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('Error: Failed to load'), findsOneWidget);
  });
}