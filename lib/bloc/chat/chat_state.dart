import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitState extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatSuccessState extends ChatState {
  Stream<QuerySnapshot> chats;
  ChatSuccessState(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatFailureState extends ChatState {

  @override
  List<Object> get props => [];
}

class ChatMessageSentSuccessOrFailurState extends ChatState {
  final bool isSent;
  ChatMessageSentSuccessOrFailurState(this.isSent);

  @override
  List<Object> get props => [isSent];
}

class ChatChangesState extends ChatState {
  @override
  List<Object> get props => [];
}
