import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Mocks
class MockRegisterViewModel extends Mock implements RegisterViewModel {}

class FakeRegisterEvent extends Fake implements RegisterEvent {}

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;
  late MockUserLoginUsecase mockUserLoginUsecase;

  setUpAll(() {
    registerFallbackValue(FakeRegisterEvent());
    final sl = GetIt.instance;
    mockUserLoginUsecase = MockUserLoginUsecase();

    if (!sl.isRegistered<UserLoginUsecase>()) {
      sl.registerSingleton<UserLoginUsecase>(mockUserLoginUsecase);
    }
  });

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
    mockUserLoginUsecase = MockUserLoginUsecase();

    when(() => mockRegisterViewModel.state).thenReturn(RegisterState.initial());
    when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.value(RegisterState.initial()));
  });

  Widget createTestWidget({Widget? child}) {
    return MaterialApp(
      home: child ??
          BlocProvider<RegisterViewModel>.value(
            value: mockRegisterViewModel,
            child: const RegisterView(),
          ),
      routes: {
        '/login': (context) => BlocProvider<LoginViewModel>(
              create: (_) => LoginViewModel(mockUserLoginUsecase),
              child: const LoginWrapper(),
            ),
      },
    );
  }

  group('RegisterView Widget Tests', () {
    testWidgets('renders initial UI correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text("Create Your Account"), findsOneWidget);
      expect(find.text("Your perfect venue, just a click away!"), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, "Full Name"), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, "Email"), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, "Phone Number"), findsOneWidget);
      expect(find.widgetWithText(CommonTextFormField, "Password"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Sign Up"), findsOneWidget);
    });

    testWidgets('shows validation errors when form is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
      await tester.pump();

      expect(find.text('Enter full name'), findsOneWidget);
      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Enter valid phone number'), findsOneWidget);
      expect(find.text('Password too short'), findsOneWidget);
    });

    testWidgets('shows validation errors with invalid input', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(CommonTextFormField, "Email"), "invalid");
      await tester.enterText(find.widgetWithText(CommonTextFormField, "Phone Number"), "123");
      await tester.enterText(find.widgetWithText(CommonTextFormField, "Password"), "abc");

      await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Enter valid phone number'), findsOneWidget);
      expect(find.text('Password too short'), findsOneWidget);
    });

    testWidgets('dispatches RegisterUserEvent on valid submission', (tester) async {
      await tester.pumpWidget(createTestWidget());

      const testName = 'John Doe';
      const testEmail = 'john@example.com';
      const testPhone = '9876543210';
      const testPassword = 'password123';

      await tester.enterText(find.widgetWithText(CommonTextFormField, "Full Name"), testName);
      await tester.enterText(find.widgetWithText(CommonTextFormField, "Email"), testEmail);
      await tester.enterText(find.widgetWithText(CommonTextFormField, "Phone Number"), testPhone);
      await tester.enterText(find.widgetWithText(CommonTextFormField, "Password"), testPassword);

      await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
      await tester.pump();

      verify(() => mockRegisterViewModel.add(any(
            that: isA<RegisterUserEvent>()
                .having((e) => e.name, 'name', testName)
                .having((e) => e.email, 'email', testEmail)
                .having((e) => e.phone, 'phone', testPhone)
                .having((e) => e.password, 'password', testPassword),
          ))).called(1);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      when(() => mockRegisterViewModel.state)
          .thenReturn(const RegisterState(isLoading: true, isSuccess: false));
      when(() => mockRegisterViewModel.stream)
          .thenAnswer((_) => Stream.value(const RegisterState(isLoading: true, isSuccess: false)));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Sign Up"), findsNothing);
    });

    testWidgets('navigates to LoginWrapper on "Log In!" tap', (tester) async {
      await tester.pumpWidget(
        createTestWidget()
      );

      expect(find.text('Create Your Account'), findsOneWidget);

      
      final loginNavigatorFinder = find.byKey(const Key('login_navigator'));
      await tester.ensureVisible(loginNavigatorFinder);
      await tester.tap(loginNavigatorFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LoginWrapper), findsOneWidget);
    });
  });
}
