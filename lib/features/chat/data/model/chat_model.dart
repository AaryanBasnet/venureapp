import 'package:hive/hive.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 4) // Unique typeId for ChatModel
class ChatModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<Participant> participants;

  @HiveField(2)
  final String venueId;

  @HiveField(3)
  final String? venueName;

  @HiveField(4)
  final String? lastMessage;

  @HiveField(5)
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.participants,
    required this.venueId,
    this.venueName,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e is String
              ? Participant(id: e, name: '')
              : Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      venueId: json['venueId'] is String
          ? json['venueId'] as String
          : (json['venueId'] as Map<String, dynamic>)['_id'] as String,
      venueName: json['venueId'] is Map<String, dynamic>
          ? (json['venueId'] as Map<String, dynamic>)['venueName'] as String?
          : null,
      lastMessage: json['lastMessage']?['text'] as String?,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'participants': participants.map((p) => p.toJson()).toList(),
        'venueId': venueId,
        'lastMessage': lastMessage,
        'unreadCount': unreadCount,
      };

  ChatEntity toEntity({required String currentUserId}) {
    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );

    return ChatEntity(
      id: id,
      participants: participants.map((p) => p.id).toList(),
      venueId: venueId,
      venueName: venueName ?? '',
      lastMessage: lastMessage ?? '',
      unreadCount: unreadCount,
      participantId: otherParticipant.id,
      participantName: otherParticipant.name,
    );
  }
}

@HiveType(typeId: 5) // Unique typeId for Participant
class Participant {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Participant({required this.id, required this.name});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}
