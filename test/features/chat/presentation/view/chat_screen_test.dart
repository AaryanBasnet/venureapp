import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/presentation/view/chat_screen.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_state.dart';
import 'package:venure/features/chat/presentation/widgets/message_bubble.dart';

// Mock Bloc class
class MockChatMessagesBloc extends Mock implements ChatMessagesBloc {}

class FakeChatMessagesEvent extends Fake implements ChatMessagesEvent {}

class FakeChatMessagesState extends Fake implements ChatMessagesState {}

void main() {
  late MockChatMessagesBloc mockChatMessagesBloc;

  setUpAll(() {
    registerFallbackValue(FakeChatMessagesEvent());
    registerFallbackValue(FakeChatMessagesState());
  });

  setUp(() {
    mockChatMessagesBloc = MockChatMessagesBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ChatMessagesBloc>.value(
        value: mockChatMessagesBloc,
        child: ChatScreen(
          chatId: 'chat1',
          currentUserId: 'user1',
          otherUserId: 'user2',
          venueId: 'venue1',
        ),
      ),
    );
  }

  testWidgets('adds LoadChatMessages event on build', (tester) async {
    when(() => mockChatMessagesBloc.state).thenReturn(ChatMessagesInitial());
    when(() => mockChatMessagesBloc.stream).thenAnswer((_) => Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    verify(() => mockChatMessagesBloc.add(LoadChatMessages('chat1'))).called(1);
  });

  testWidgets('shows loading indicator when loading', (tester) async {
    when(() => mockChatMessagesBloc.state).thenReturn(ChatMessagesLoading());
    when(() => mockChatMessagesBloc.stream).thenAnswer((_) => Stream.value(ChatMessagesLoading()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows message list when loaded', (tester) async {
    final messages = [
      MessageEntity(
        id: 'm1',
        chatId: 'chat1',
        senderId: 'user1',
        text: 'Hello',
        timestamp: DateTime.now(),
        receiverId: '',
        seen: false,
      ),
      MessageEntity(
        id: 'm2',
        chatId: 'chat1',
        senderId: 'user2',
        text: 'Hi there!',
        timestamp: DateTime.now(),
        receiverId: '',
        seen: false,
      ),
    ];

    when(() => mockChatMessagesBloc.state).thenReturn(ChatMessagesLoaded(messages));
    when(() => mockChatMessagesBloc.stream).thenAnswer((_) => Stream.value(ChatMessagesLoaded(messages)));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Hi there!'), findsOneWidget);
    expect(find.byType(MessageBubble), findsNWidgets(2));
  });

  testWidgets('shows error message when error state', (tester) async {
    when(() => mockChatMessagesBloc.state).thenReturn(const ChatMessagesError('Failed to load'));
    when(() => mockChatMessagesBloc.stream).thenAnswer((_) => Stream.value(const ChatMessagesError('Failed to load')));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.textContaining('Failed to load chat: Failed to load'), findsOneWidget);
  });
}
