import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_event.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_state.dart';
import 'package:flutter_fire_chat/services/firestore_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitState());
  final FirestoreService firestoreService = FirestoreService();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatInitAction) {
      yield* _mapChatInitStateToState(event);
    } else if (event is ChatRetriveAction) {
      yield* _mapChatRetriveStateToState(event);
    } else if (event is ChatMessageSendAction) {
      yield* _mapChatMessageSendStateToState(event);
    } else if (event is ChatChangesAction) {
      yield* _mapChatChangeStateToState(event);
    }
  }

  Stream<ChatState> _mapChatInitStateToState(ChatInitAction event) async* {
    yield ChatInitState();
  }

  Stream<ChatState> _mapChatRetriveStateToState(ChatRetriveAction event) async* {
    try {
      Stream<QuerySnapshot> chats = await firestoreService.getChats(event.chatRoomsId);

      yield ChatSuccessState(chats);
    } catch (e) {
      print("getChats() Error : ${e.toString()}");

      yield ChatFailureState();
    }
  }

  Stream<ChatState> _mapChatMessageSendStateToState(ChatMessageSendAction event) async* {
    try {
      await firestoreService.addMessage(event.chatRoomsId, event.chatMessageMap);

      yield ChatMessageSentSuccessOrFailurState(true);
    } catch (e) {
      print("addMessage() Error : ${e.toString()}");

      yield ChatMessageSentSuccessOrFailurState(false);
    }
  }

  Stream<ChatState> _mapChatChangeStateToState(ChatChangesAction event) async* {
    yield ChatChangesState();
  }
}
