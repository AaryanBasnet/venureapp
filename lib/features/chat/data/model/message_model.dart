import 'package:hive/hive.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';

part 'message_model.g.dart';

@HiveType(typeId: 6)
class MessageModel extends MessageEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chatId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String receiverId;

  @HiveField(4)
  final String text;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final bool seen;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.seen,
  }) : super(
         id: id,
         chatId: chatId,
         senderId: senderId,
         receiverId: receiverId,
         text: text,
         timestamp: timestamp,
         seen: seen,
       );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['sender']?['_id'] as String, // nested object _id
      receiverId: json['receiver']?['_id'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['createdAt'] as String),
      seen: false, // createdAt not timestamp
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'chatId': chatId,
    'sender': senderId,
    'receiver': receiverId,
    'text': text,
    'createdAt': timestamp.toIso8601String(),
    'seen': seen,
  };

  @override
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: timestamp,
      seen: seen,
    );
  }
}
