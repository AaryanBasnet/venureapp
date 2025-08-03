import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/forget_password_screen.dart';
import 'package:venure/features/auth/presentation/view/login_view.dart';
import 'package:venure/features/auth/presentation/view/register_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// --- Mock classes ---
class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockRegisterViewModel extends Mock implements RegisterViewModel {}

class MockForgotPasswordViewModel extends Mock
    implements ForgotPasswordViewModel {}

class MockSendResetCodeUsecase extends Mock implements SendResetCodeUseCase {}

class MockVerifyResetCodeUsecase extends Mock
    implements VerifyResetCodeUseCase {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUseCase {}

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// --- Fake classes ---
class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeRegisterEvent extends Fake implements RegisterEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  final sl = GetIt.instance;

  late MockLoginViewModel mockLoginViewModel;
  late MockRegisterViewModel mockRegisterViewModel;
  late MockForgotPasswordViewModel mockForgotPasswordViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeRegisterEvent());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    sl.reset();

    sl.registerLazySingleton<SendResetCodeUseCase>(
      () => MockSendResetCodeUsecase(),
    );
    sl.registerLazySingleton<VerifyResetCodeUseCase>(
      () => MockVerifyResetCodeUsecase(),
    );
    sl.registerLazySingleton<ResetPasswordUseCase>(
      () => MockResetPasswordUsecase(),
    );
    sl.registerLazySingleton<UserRegisterUsecase>(
      () => MockUserRegisterUsecase(),
    );

    mockLoginViewModel = MockLoginViewModel();
    mockRegisterViewModel = MockRegisterViewModel();
    mockForgotPasswordViewModel = MockForgotPasswordViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Default mock state for LoginViewModel
    when(
      () => mockLoginViewModel.state,
    ).thenReturn(const LoginState(isLoading: false, isSuccess: false));
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => const Stream<LoginState>.empty());

    // Default mock state for RegisterViewModel
    when(() => mockRegisterViewModel.state).thenReturn(RegisterState.initial());
    when(
      () => mockRegisterViewModel.stream,
    ).thenAnswer((_) => Stream.value(RegisterState.initial()));

    // Mock any Future<void> methods in RegisterViewModel
    when(() => mockRegisterViewModel.add(any())).thenReturn(null);
    when(() => mockRegisterViewModel.close()).thenAnswer((_) async {});
    
    // If RegisterViewModel has initialization methods, mock them:
    // when(() => mockRegisterViewModel.initialize()).thenAnswer((_) async {});
    // when(() => mockRegisterViewModel.loadData()).thenAnswer((_) async {});
    
    // Mock any navigation methods if they exist
    // when(() => mockRegisterViewModel.navigateBack()).thenAnswer((_) async {});
    
    // If there are validation methods:
    // when(() => mockRegisterViewModel.validateForm()).thenAnswer((_) async {});
    
    // If there are API calls:
    // when(() => mockRegisterViewModel.submitRegistration()).thenAnswer((_) async {});

    // Default mock state for ForgotPasswordViewModel
    when(
      () => mockForgotPasswordViewModel.state,
    ).thenReturn(const ForgotPasswordState());
    when(
      () => mockForgotPasswordViewModel.stream,
    ).thenAnswer((_) => const Stream<ForgotPasswordState>.empty());
  });

  Widget createTestWidget(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
        BlocProvider<RegisterViewModel>.value(value: mockRegisterViewModel),
        BlocProvider<ForgotPasswordViewModel>.value(
          value: mockForgotPasswordViewModel,
        ),
      ],
      child: MaterialApp(
        home: child,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
  }

  group('LoginView widget tests', () {
    testWidgets('renders initial UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginView()));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('VENURE'), findsOneWidget);
      expect(find.text('Luxury • Redefined'), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, 'Email'), findsOneWidget);
      expect(
        find.widgetWithText(CommonTextFormField, 'Password'),
        findsOneWidget,
      );
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('dispatches LoginIntoSystemEvent on Login button tap', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const LoginView()));

      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      await tester.enterText(
        find.widgetWithText(CommonTextFormField, 'Email'),
        testEmail,
      );
      await tester.enterText(
        find.widgetWithText(CommonTextFormField, 'Password'),
        testPassword,
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      verify(
        () => mockLoginViewModel.add(
          any(
            that: isA<LoginIntoSystemEvent>()
                .having((e) => e.email, 'email', testEmail)
                .having((e) => e.password, 'password', testPassword),
          ),
        ),
      ).called(1);
    });

    testWidgets('shows loading indicator and disables button during loading', (
      tester,
    ) async {
      when(
        () => mockLoginViewModel.state,
      ).thenReturn(const LoginState(isLoading: true, isSuccess: false));
      when(() => mockLoginViewModel.stream).thenAnswer(
        (_) =>
            Stream.value(const LoginState(isLoading: true, isSuccess: false)),
      );

      await tester.pumpWidget(createTestWidget(const LoginView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets(
      'navigates to ForgotPasswordScreen when "Forgot password?" tapped',
      (tester) async {
        await tester.pumpWidget(createTestWidget(const LoginView()));
        
        // Reset the mock to clear any previous calls
        reset(mockNavigatorObserver);
        
        await tester.tap(find.text('Forgot password?'));
        await tester.pumpAndSettle();

        // Verify only the navigation we triggered
        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      },
    );

    testWidgets('navigates to RegisterWrapper when "Sign Up" tapped', (
      tester,
    ) async {
      // Mock any methods that RegisterWrapper constructor might call
      when(() => mockRegisterViewModel.add(any())).thenReturn(null);
      when(() => mockRegisterViewModel.close()).thenAnswer((_) async {});
      
      await tester.pumpWidget(
        createTestWidget(LoginView(registerViewModel: mockRegisterViewModel)),
      );
      
      // Reset the mock to clear any previous calls  
      reset(mockNavigatorObserver);

      await tester.tap(find.text('Sign Up'));
      
      // Use pump() instead of pumpAndSettle() to avoid waiting for animations
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify navigation occurred
      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      
      // Alternative: Check if RegisterWrapper is in the widget tree
      // This might be more reliable than checking the exact widget type
      expect(find.byType(RegisterWrapper), findsOneWidget);
    });
  });
}