import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/features/booking/presentation/view/addons_page.dart';

class MockOnNext extends Mock {
  void call(Map<String, dynamic> data);
}

class MockOnBack extends Mock {
  void call();
}

void main() {
  late MockOnNext mockOnNext;
  late MockOnBack mockOnBack;

  setUp(() {
    mockOnNext = MockOnNext();
    mockOnBack = MockOnBack();
  });

  Future<void> pumpAddonsPage({
    required WidgetTester tester,
    List<Map<String, dynamic>> initialAddons = const [],
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddonsPage(
            initialAddons: initialAddons,
            onNext: mockOnNext,
            onBack: mockOnBack,
          ),
        ),
      ),
    );
  }

  testWidgets('renders all addons and buttons', (tester) async {
    await pumpAddonsPage(tester: tester);

    expect(find.text('Select Add-ons'), findsOneWidget);
    expect(find.text('Catering'), findsOneWidget);
    expect(find.text('Decoration'), findsOneWidget);
    expect(find.text('DJ'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('pressing back triggers onBack', (tester) async {
    await pumpAddonsPage(tester: tester);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    verify(() => mockOnBack()).called(1);
  });

  testWidgets('selects and submits single addon', (tester) async {
    await pumpAddonsPage(tester: tester);

    await tester.tap(find.widgetWithText(CheckboxListTile, 'Catering'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final captured =
        verify(() => mockOnNext(captureAny())).captured.single
            as Map<String, dynamic>;
    final selected = captured['selectedAddons'] as List;

    expect(selected.length, 1);
    expect(selected.first['name'], 'Catering');
  });

  testWidgets('selects multiple addons and submits', (tester) async {
    await pumpAddonsPage(tester: tester);

    await tester.tap(find.widgetWithText(CheckboxListTile, 'Catering'));
    await tester.tap(find.widgetWithText(CheckboxListTile, 'DJ'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final captured =
        verify(() => mockOnNext(captureAny())).captured.single
            as Map<String, dynamic>;
    final selected = captured['selectedAddons'] as List;

    expect(selected.length, 2);
    expect(selected.any((a) => a['name'] == 'Catering'), isTrue);
    expect(selected.any((a) => a['name'] == 'DJ'), isTrue);
  });

  testWidgets('deselecting removes addon', (tester) async {
    await pumpAddonsPage(tester: tester);

    final cateringCheckbox = find.widgetWithText(CheckboxListTile, 'Catering');
    await tester.tap(cateringCheckbox); // select
    await tester.pumpAndSettle();
    await tester.tap(cateringCheckbox); // deselect
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final captured =
        verify(() => mockOnNext(captureAny())).captured.single
            as Map<String, dynamic>;
    final selected = captured['selectedAddons'] as List;

    expect(selected.isEmpty, true);
  });

  testWidgets('uses initialAddons correctly', (tester) async {
    final initial = [
      {'id': '2', 'name': 'Decoration', 'price': 3000, 'perPerson': false},
    ];

    await pumpAddonsPage(tester: tester, initialAddons: initial);
    await tester.pumpAndSettle();

    final decorationCheckbox = find.widgetWithText(
      CheckboxListTile,
      'Decoration',
    );
    final checkbox = tester.widget<CheckboxListTile>(decorationCheckbox);
    expect(checkbox.value, isTrue);
  });

  testWidgets('pressing next with no selection still returns empty list', (
    tester,
  ) async {
    await pumpAddonsPage(tester: tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final captured =
        verify(() => mockOnNext(captureAny())).captured.single
            as Map<String, dynamic>;
    expect((captured['selectedAddons'] as List).isEmpty, true);
  });
}
