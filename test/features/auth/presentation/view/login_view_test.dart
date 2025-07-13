import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/common/common_text_form_field.dart';

import 'package:venure/features/auth/presentation/view/login_view.dart';
import 'package:venure/features/auth/presentation/view/register_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';

// --- Mock classes ---

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockRegisterViewModel extends Mock implements RegisterViewModel {}

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class FakeLoginEvent extends Fake implements LoginEvent {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  final sl = GetIt.instance;

  late MockLoginViewModel mockLoginViewModel;
  late MockRegisterViewModel mockRegisterViewModel;
  late MockUserRegisterUsecase mockUserRegisterUsecase;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeRoute());

    // Register mock UserRegisterUsecase with GetIt
    mockUserRegisterUsecase = MockUserRegisterUsecase();
    if (!sl.isRegistered<UserRegisterUsecase>()) {
      sl.registerLazySingleton<UserRegisterUsecase>(() => mockUserRegisterUsecase);
    }
  });

  tearDownAll(() {
    sl.reset(); // Clear all registered dependencies after tests
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockRegisterViewModel = MockRegisterViewModel();

    // Mock LoginViewModel state & stream
    when(() => mockLoginViewModel.state)
        .thenReturn(const LoginState(isLoading: false, isSuccess: false));
    when(() => mockLoginViewModel.stream).thenAnswer((_) => const Stream<LoginState>.empty());

    // Mock RegisterViewModel state & stream
    when(() => mockRegisterViewModel.state).thenReturn(RegisterState.initial());
    when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.value(RegisterState.initial()));
  });

  Widget createLoginWidget() {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: const LoginView(),
      ),
    );
  }

  Widget createLoginWithRegisterNavigationWidget(MockNavigatorObserver mockObserver) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
          BlocProvider<RegisterViewModel>.value(value: mockRegisterViewModel),
        ],
        child: const LoginView(),
      ),
      navigatorObservers: [mockObserver],
      routes: {
        '/register': (context) => BlocProvider.value(
              value: mockRegisterViewModel,
              child: const RegisterWrapper(),
            ),
      },
    );
  }

  testWidgets('renders all LoginView UI elements', (tester) async {
    await tester.pumpWidget(createLoginWidget());

    expect(find.text("Sign in to your account!"), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text("Forgot password?"), findsOneWidget);
    expect(find.text("Login"), findsOneWidget);
    expect(find.text("Login with Google"), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text("Sign Up!"), findsOneWidget);
  });

  testWidgets('enters email and password and dispatches login event', (tester) async {
    await tester.pumpWidget(createLoginWidget());

    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    await tester.enterText(find.byType(CommonTextFormField).at(0), testEmail);
    await tester.enterText(find.byType(CommonTextFormField).at(1), testPassword);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(() => mockLoginViewModel.add(
          any(
            that: isA<LoginIntoSystemEvent>()
                .having((e) => e.email, 'email', testEmail)
                .having((e) => e.password, 'password', testPassword),
          ),
        )).called(1);
  });

  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    when(() => mockLoginViewModel.state)
        .thenReturn(const LoginState(isLoading: true, isSuccess: false));
    when(() => mockLoginViewModel.stream)
        .thenAnswer((_) => Stream.value(const LoginState(isLoading: true, isSuccess: true)));

    await tester.pumpWidget(createLoginWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("Login"), findsNothing);
  });

  testWidgets('Google login button is tappable', (tester) async {
    await tester.pumpWidget(createLoginWidget());

    final googleLoginBtn = find.text("Login with Google");
    expect(googleLoginBtn, findsOneWidget);

    await tester.tap(googleLoginBtn);
    await tester.pump();

    // It's tappable (no action asserted here)
  });

  testWidgets('Forgot password button is tappable', (tester) async {
    await tester.pumpWidget(createLoginWidget());

    final forgotBtn = find.text("Forgot password?");
    expect(forgotBtn, findsOneWidget);

    await tester.tap(forgotBtn);
    await tester.pump();

    // No navigation asserted, just no crash
  });

  testWidgets('Sign Up button navigates to RegisterWrapper', (tester) async {
    final mockObserver = MockNavigatorObserver();

    when(() => mockObserver.didPush(any(), any())).thenAnswer((_) async {});
    when(() => mockObserver.didPop(any(), any())).thenAnswer((_) async {});
    when(() => mockObserver.didRemove(any(), any())).thenAnswer((_) async {});
    when(() => mockObserver.didReplace(oldRoute: any(named: 'oldRoute'), newRoute: any(named: 'newRoute')))
        .thenAnswer((_) async {});

    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(createLoginWithRegisterNavigationWidget(mockObserver));

    // Tap "Sign Up!" button to navigate
    await tester.tap(find.text("Sign Up!"));
    await tester.pumpAndSettle();

    // Verify navigation happened
    verify(() => mockObserver.didPush(any(), any())).called(greaterThanOrEqualTo(1));

    // Verify RegisterWrapper is shown
    expect(find.byType(RegisterWrapper), findsOneWidget);
  });
}
