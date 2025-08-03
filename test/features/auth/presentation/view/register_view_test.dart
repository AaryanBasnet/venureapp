import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// --- Mock classes ---
class MockRegisterViewModel extends Mock implements RegisterViewModel {}

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// --- Fake classes ---
class FakeRegisterEvent extends Fake implements RegisterEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  final sl = GetIt.instance;

  late MockRegisterViewModel mockRegisterViewModel;
  late MockUserRegisterUsecase mockUserRegisterUsecase;
  late MockLoginViewModel mockLoginViewModel;
  late MockUserLoginUsecase mockUserLoginUsecase;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeRegisterEvent());
    registerFallbackValue(FakeRoute());
    registerFallbackValue(FakeLoginEvent());

    mockUserRegisterUsecase = MockUserRegisterUsecase();
    mockRegisterViewModel = MockRegisterViewModel();

    mockUserLoginUsecase = MockUserLoginUsecase();
    mockLoginViewModel = MockLoginViewModel();

    if (!sl.isRegistered<UserRegisterUsecase>()) {
      sl.registerLazySingleton<UserRegisterUsecase>(
        () => mockUserRegisterUsecase,
      );
    }
    if (!sl.isRegistered<UserLoginUsecase>()) {
      sl.registerLazySingleton<UserLoginUsecase>(() => mockUserLoginUsecase);
    }
    if (!sl.isRegistered<LoginViewModel>()) {
      sl.registerFactory<LoginViewModel>(() => mockLoginViewModel);
    }
  });

  tearDownAll(() {
    sl.reset();
  });

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();

    when(() => mockRegisterViewModel.state).thenReturn(RegisterState.initial());
    when(() => mockRegisterViewModel.stream)
        .thenAnswer((_) => Stream.value(RegisterState.initial()));

    when(() => mockLoginViewModel.state)
        .thenReturn(const LoginState(isLoading: false, isSuccess: false));
    when(() => mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createTestWidget(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterViewModel>.value(value: mockRegisterViewModel),
        BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
      ],
      child: MaterialApp(
        home: child,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
  }

  group('RegisterView', () {
    testWidgets('renders all static UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget(const RegisterView()));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('VENURE'), findsOneWidget);
      expect(find.text('Luxury • Redefined'), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, 'Full Name'), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, 'Phone Number'), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Log In!'), findsOneWidget);
    });

    testWidgets('submits register form when valid', (tester) async {
      await tester.pumpWidget(createTestWidget(const RegisterView()));

      await tester.enterText(find.byType(CommonTextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(CommonTextFormField).at(1), 'john@example.com');
      await tester.enterText(find.byType(CommonTextFormField).at(2), '9876543210');
      await tester.enterText(find.byType(CommonTextFormField).at(3), 'password123');

      final signUpButtonFinder = find.widgetWithText(ElevatedButton, 'Sign Up');

      await tester.ensureVisible(signUpButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(signUpButtonFinder);
      await tester.pumpAndSettle();

      verify(
        () => mockRegisterViewModel.add(
          any(
            that: isA<RegisterUserEvent>()
                .having((e) => e.name, 'name', 'John Doe')
                .having((e) => e.email, 'email', 'john@example.com')
                .having((e) => e.phone, 'phone', '9876543210')
                .having((e) => e.password, 'password', 'password123'),
          ),
        ),
      ).called(1);
    });

    testWidgets('does not submit when form invalid', (tester) async {
      await tester.pumpWidget(createTestWidget(const RegisterView()));

      final signUpButtonFinder = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signUpButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(signUpButtonFinder);
      await tester.pumpAndSettle();

      verifyNever(() => mockRegisterViewModel.add(any()));
    });

    testWidgets('shows loading state disables button and shows progress indicator', (tester) async {
      when(() => mockRegisterViewModel.state).thenReturn(RegisterState.initial().copyWith(isLoading: true));

      await tester.pumpWidget(createTestWidget(const RegisterView()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final ElevatedButton btn = tester.widget(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('navigates to LoginWrapper when Log In! is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget(const RegisterView()));

      await tester.ensureVisible(find.text('Log In!'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In!'));
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(2);
      expect(find.byType(LoginWrapper), findsOneWidget);
    });

    testWidgets('calls onSuccess callback and prints registration success', (tester) async {
      await tester.pumpWidget(createTestWidget(const RegisterView()));

      // Fill the form
      await tester.enterText(find.byType(CommonTextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(CommonTextFormField).at(1), 'john@example.com');
      await tester.enterText(find.byType(CommonTextFormField).at(2), '9876543210');
      await tester.enterText(find.byType(CommonTextFormField).at(3), 'password123');

      final signUpButtonFinder = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signUpButtonFinder);
      await tester.pumpAndSettle();

      String? printedMessage;
      final originalDebugPrint = debugPrint;

      debugPrint = (String? message, {int? wrapWidth}) {
        printedMessage = message;
      };

      await tester.tap(signUpButtonFinder);
      await tester.pump();

      final captured = verify(() => mockRegisterViewModel.add(captureAny())).captured;
      expect(captured.length, 1);
      final RegisterUserEvent event = captured.first as RegisterUserEvent;

      // Invoke the onSuccess callback from the captured event
      event.onSuccess();

      expect(printedMessage, "Registration successful");

      debugPrint = originalDebugPrint;
    });
  });
}
