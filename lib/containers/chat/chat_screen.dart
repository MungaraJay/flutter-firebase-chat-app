import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_bloc.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_event.dart';
import 'package:flutter_fire_chat/bloc/chat/chat_state.dart';
import 'package:flutter_fire_chat/containers/chat/chat_arguments.dart';
import 'package:flutter_fire_chat/containers/chat/message_tile.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';
import 'package:flutter_fire_chat/utils/util_strings.dart';
import 'package:flutter_fire_chat/widgets/custom_chat_input.dart';
import 'package:flutter_fire_chat/widgets/custom_icon_button.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> chats;
  ScrollController scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();
  FocusNode _textFocusNode = FocusNode();
  ChatArguments chatArguments;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchUserParams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        try {
          if (state is ChatSuccessState) {
            chats = state.chats;
            WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

            BlocProvider.of<ChatBloc>(context).add(ChatChangesAction());
          } else if (state is ChatFailureState) {
            BlocProvider.of<ChatBloc>(context).add(ChatChangesAction());
          } else if (state is ChatMessageSentSuccessOrFailurState){
            WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

            BlocProvider.of<ChatBloc>(context).add(ChatChangesAction());
          }
        } catch (e) {
          print(e);
        }

        return Scaffold(
          backgroundColor: colorScaffoldBG,
          appBar: AppBar(
            centerTitle: true,
            title: Text(strUser),
          ),
          body: Column(
            children: [
              Expanded(child: chatMessages()),
              SafeArea(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomChatInput(
                              textController: _textController,
                              hintText: strMessage)),
                      CustomIconButton(
                          iconData: Icons.send,
                          onPressed: () {
                            addMessage();
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data.documents.length == 0
                ? Container()
                : ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data.docs[index].data();
                      return MessageTile(
                          message: item[User_Message],
                          sendByMe: auth.currentUser.uid == item[User_SendBy],
                          time: item[User_Time]);
                    })
            : Container();
      },
    );
  }

  scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      Timer(Duration(milliseconds: 100), () => scrollToBottom());
    }
  }

  fetchUserParams() async {
    chatArguments = ModalRoute.of(context).settings.arguments;
    BlocProvider.of<ChatBloc>(context).add(ChatRetriveAction(chatArguments.chatRoomId));
  }

  addMessage() {
    if (_textController.text.trim().isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        User_SendBy : auth.currentUser.uid,
        User_Message : _textController.text.trim(),
        User_Time : DateTime.now().millisecondsSinceEpoch,
      };

      if (chatArguments == null) {
        chatArguments = ModalRoute.of(context).settings.arguments;
      }
      _textController.text = "";
      BlocProvider.of<ChatBloc>(context).add(ChatMessageSendAction(chatMessageMap, chatArguments.chatRoomId));
    }
  }
}
