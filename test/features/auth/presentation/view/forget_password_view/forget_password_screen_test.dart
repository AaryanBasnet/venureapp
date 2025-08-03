import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// Your app's imports
import 'package:venure/app/service_locator/service_locator.dart' as di;
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/forget_password_screen.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/verify_reset_code_screen.dart';

// --- Mocks created with Mocktail ---
class MockSendResetCodeUseCase extends Mock implements SendResetCodeUseCase {}

class MockVerifyResetCodeUseCase extends Mock
    implements VerifyResetCodeUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockNavigator extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

// --- Fake class from Mocktail for non-primitive types ---
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late SendResetCodeUseCase mockSendResetCodeUseCase;
  late VerifyResetCodeUseCase mockVerifyResetCodeUseCase;
  late ResetPasswordUseCase mockResetPasswordUseCase;
  late MockNavigator mockNavigator;

  setUp(() {
    mockSendResetCodeUseCase = MockSendResetCodeUseCase();
    mockVerifyResetCodeUseCase = MockVerifyResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockNavigator = MockNavigator();

    di.serviceLocator.allowReassignment = true;

    di.serviceLocator.registerSingleton<SendResetCodeUseCase>(
      mockSendResetCodeUseCase,
    );
    di.serviceLocator.registerSingleton<VerifyResetCodeUseCase>(
      mockVerifyResetCodeUseCase,
    );
    di.serviceLocator.registerSingleton<ResetPasswordUseCase>(
      mockResetPasswordUseCase,
    );

    // Necessary Mocktail setup for complex argument types
    registerFallbackValue(FakeRoute());
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ForgotPasswordScreen(),
        navigatorObservers: [mockNavigator],
      ),
    );
  }

  group('ForgotPasswordScreen', () {
    testWidgets('shows success snackbar and navigates on successful code send', (
      tester,
    ) async {
      // Arrange
      const email = 'test@example.com';
      when(
        () => mockSendResetCodeUseCase(any()),
      ).thenAnswer((_) async => const Right(null));
      // **CHANGE 1**: We don't need to stub a method on the observer.
      // The observer just listens, so the `when` call for navigation is removed.

      // Act
      await pumpScreen(tester);
      await tester.enterText(find.byType(TextField), email);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Reset code sent! Check your email'), findsOneWidget);

      // **CHANGE 2**: Verify `didReplace` was called on the observer.
      final captured =
          verify(
            () => mockNavigator.didReplace(
              newRoute: captureAny(named: 'newRoute'),
              oldRoute: any(named: 'oldRoute'),
            ),
          ).captured;

      // The captured argument is the new route that was pushed.
      final newRoute = captured.last as MaterialPageRoute;
      expect(newRoute, isA<MaterialPageRoute>());

      final nextScreen =
          newRoute.builder(MockBuildContext()) as VerifyResetCodeScreen;
      expect(nextScreen.email, email);
    });

    testWidgets('shows error snackbar on failed code send', (tester) async {
      // Arrange
      const errorMessage = 'Invalid email or user not found.';
      when(
        () => mockSendResetCodeUseCase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: errorMessage)));

      // Act
      await pumpScreen(tester);
      await tester.enterText(find.byType(TextField), 'wrong@example.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
