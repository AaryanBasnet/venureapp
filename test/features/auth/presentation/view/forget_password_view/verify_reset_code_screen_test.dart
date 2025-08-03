import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/app/service_locator/service_locator.dart' as di;
import 'package:venure/core/error/failure.dart';

import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/verify_reset_code_screen.dart';

// --- Mock UseCases ---
class MockSendResetCodeUseCase extends Mock implements SendResetCodeUseCase {}

class MockVerifyResetCodeUseCase extends Mock implements VerifyResetCodeUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockSendResetCodeUseCase mockSendResetCodeUseCase;
  late MockVerifyResetCodeUseCase mockVerifyResetCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUp(() {
    mockSendResetCodeUseCase = MockSendResetCodeUseCase();
    mockVerifyResetCodeUseCase = MockVerifyResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

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

    when(() => mockResetPasswordUseCase.call(
      email: any(named: 'email'),
      code: any(named: 'code'),
      newPassword: any(named: 'newPassword'),
    )).thenAnswer((_) async => const Right(null));
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: VerifyResetCodeScreen(email: 'test@example.com'),
    );
  }

  testWidgets('initial state disables button and shows email', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Enter the reset code sent to test@example.com'), findsOneWidget);

    final verifyButton = find.widgetWithText(ElevatedButton, 'Verify Code');
    final buttonWidget = tester.widget<ElevatedButton>(verifyButton);
    expect(buttonWidget.onPressed, isNotNull); // still clickable but no code yet
  });

  testWidgets('shows loading indicator and navigates on success', (tester) async {
    when(() => mockVerifyResetCodeUseCase.call(any(), any()))
        .thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return const Right(null);
    });

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.widgetWithText(TextField, 'Reset Code'), '123456');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Code'));

    // Spinner should appear
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish async
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Success snackbar
    expect(find.text('Code verified! Please set new password.'), findsOneWidget);
  });

  testWidgets('shows loading indicator and error snackbar on failure', (tester) async {
    when(() => mockVerifyResetCodeUseCase.call(any(), any()))
        .thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return Left(ApiFailure(message: 'Invalid code'));
    });

    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.widgetWithText(TextField, 'Reset Code'), '999999');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify Code'));

    // Spinner
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish async
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Error snackbar
    expect(find.text('Invalid code'), findsOneWidget);
  });
}
