import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/app/service_locator/service_locator.dart' as di;
import 'package:venure/core/error/failure.dart';

import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/reset_password_screen.dart';

// --- Mock UseCases ---
class MockSendResetCodeUseCase extends Mock implements SendResetCodeUseCase {}

class MockVerifyResetCodeUseCase extends Mock
    implements VerifyResetCodeUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockSendResetCodeUseCase mockSendResetCodeUseCase;
  late MockVerifyResetCodeUseCase mockVerifyResetCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUp(() {
    mockSendResetCodeUseCase = MockSendResetCodeUseCase();
    mockVerifyResetCodeUseCase = MockVerifyResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    // Allow service locator re-registration
    di.serviceLocator.allowReassignment = true;
    di.serviceLocator
      ..registerSingleton<SendResetCodeUseCase>(mockSendResetCodeUseCase)
      ..registerSingleton<VerifyResetCodeUseCase>(mockVerifyResetCodeUseCase)
      ..registerSingleton<ResetPasswordUseCase>(mockResetPasswordUseCase);

    // Default stubs
    when(() => mockSendResetCodeUseCase.call(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => mockVerifyResetCodeUseCase.call(any(), any()))
        .thenAnswer((_) async => const Right(null));
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ResetPasswordScreen(email: 'test@example.com', code: '123456'),
    );
  }

  testWidgets('initial state disables button and shows email', (tester) async {
    // Arrange
    when(() => mockResetPasswordUseCase.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async => const Right(null));

    // Act
    await tester.pumpWidget(createTestWidget());

    // Assert
    expect(find.text('Set a new password for test@example.com'), findsOneWidget);

    final resetButton = find.widgetWithText(ElevatedButton, 'Reset Password');
    final buttonWidget = tester.widget<ElevatedButton>(resetButton);
    expect(buttonWidget.onPressed, isNull);
  });

  testWidgets('enables button when passwords match', (tester) async {
    when(() => mockResetPasswordUseCase.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(
        find.widgetWithText(TextField, 'New Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    await tester.pumpAndSettle();

    final resetButton = find.widgetWithText(ElevatedButton, 'Reset Password');
    final buttonWidget = tester.widget<ElevatedButton>(resetButton);
    expect(buttonWidget.onPressed, isNotNull);
  });

  testWidgets('shows loading indicator and success snackbar on reset',
      (tester) async {
    // Delay so the loading indicator is actually visible
    when(() => mockResetPasswordUseCase.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return const Right(null);
    });

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(
        find.widgetWithText(TextField, 'New Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));

    // Give the widget a frame to show the spinner
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the delayed future finish
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Verify snackbar
    expect(find.text('Password reset successful. Please login.'),
        findsOneWidget);
  });

  testWidgets('shows loading indicator and error snackbar on failure',
      (tester) async {
    // Delay so spinner is visible
    when(() => mockResetPasswordUseCase.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return Left(ApiFailure(message: 'Reset failed'));
    });

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(
        find.widgetWithText(TextField, 'New Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));

    // Spinner should appear
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let async finish
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Error snackbar
    expect(find.text('Reset failed'), findsOneWidget);
  });
}
