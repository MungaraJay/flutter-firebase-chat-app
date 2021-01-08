import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatInitAction extends ChatEvent {
  @override
  List<Object> get props => [];
}

class ChatRetriveAction extends ChatEvent {
  final String chatRoomsId;
  ChatRetriveAction(this.chatRoomsId);

  @override
  List<Object> get props => [chatRoomsId];
}

class ChatMessageSendAction extends ChatEvent {
  final Map<String, dynamic> chatMessageMap;
  final String chatRoomsId;
  ChatMessageSendAction(this.chatMessageMap, this.chatRoomsId);

  @override
  List<Object> get props => [chatMessageMap, chatRoomsId];
}

class ChatChangesAction extends ChatEvent {
  @override
  List<Object> get props => [];
}
