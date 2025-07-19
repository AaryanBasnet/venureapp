import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> participants;
  final String venueId;
  final String venueName;
  final String lastMessage;
  final int unreadCount;

  final String participantId;
  final String participantName;

  const ChatEntity({
    required this.id,
    required this.participants,
    required this.venueId,
    required this.venueName,
    this.lastMessage = '',
    this.unreadCount = 0,
    required this.participantId,
    required this.participantName,
  });

  @override
  List<Object?> get props => [
        id,
        participants,
        venueId,
        venueName,
        lastMessage,
        unreadCount,
        participantId,
        participantName,
      ];
}
