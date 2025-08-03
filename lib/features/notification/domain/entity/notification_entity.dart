import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    type,
    message,
    isRead,
    createdAt,
  ];
}
