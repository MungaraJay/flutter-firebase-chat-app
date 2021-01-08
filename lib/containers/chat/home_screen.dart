import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/home/home_bloc.dart';
import 'package:flutter_fire_chat/bloc/home/home_event.dart';
import 'package:flutter_fire_chat/bloc/home/home_state.dart';
import 'package:flutter_fire_chat/containers/chat/chat_arguments.dart';
import 'package:flutter_fire_chat/containers/chat/user_tile.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';
import 'package:flutter_fire_chat/utils/util_images.dart';
import 'package:flutter_fire_chat/utils/util_routes.dart';
import 'package:flutter_fire_chat/utils/util_strings.dart';
import 'package:flutter_fire_chat/widgets/custom_placeholder.dart';
import 'package:flutter_fire_chat/widgets/custom_progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> chatRooms;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        try {
          if (state is HomeSuccessState) {
            chatRooms = state.chatRooms;

            BlocProvider.of<HomeBloc>(context).add(HomeChangesAction());
          } else if (state is HomeFailureState) {
            BlocProvider.of<HomeBloc>(context).add(HomeChangesAction());
          } else if (state is HomeLogoutState) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Route_Auth_Screen, (route) => false);
            });

            BlocProvider.of<HomeBloc>(context).add(HomeChangesAction());
          }
        } catch (e) {
          print(e);
        }

        return Scaffold(
          backgroundColor: colorScaffoldBG,
          appBar: AppBar(
            title: Text(strChats),
            centerTitle: true,
            leading: Container(
                margin: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                child: Image.asset(userImage,
                    height: 24, width: 24, fit: BoxFit.contain)),
            actions: [
              IconButton(
                  padding: EdgeInsets.only(right: 12),
                  icon: Icon(Icons.exit_to_app, size: 32),
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeLogoutAction());
                  })
            ],
          ),
          body: getUsersBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Route_Search_Screen);
            },
            child: Icon(Icons.message, color: lightColor),
          ),
        );
      },
    );
  }

  Widget getUsersBody() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomProgressIndicator();
        }

        return snapshot.hasData
            ? snapshot.data.docs.length == 0
                ? CustomPlaceholder(message: strNoChats)
                : ListView.builder(
                    padding: EdgeInsets.only(top: 8),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var username = '';
                      var userEmail = '';
                      final item = snapshot.data.docs[index].data();

                      if (item != null && item[User_Details].length > 0) {
                        item[User_Details].forEach((element) {
                          if (auth.currentUser != null &&
                              element[User_ID] != auth.currentUser.uid) {
                            username = element[User_Name];
                            userEmail = element[User_Email];
                          }
                        });
                      }

                      return UserTile(
                          userEmail: userEmail,
                          userName: username,
                          onPressed: () {
                            ChatArguments chatArguments =
                                ChatArguments(chatRoomId: item[User_ChatRoomId]);
                            Navigator.pushNamed(context, Route_Chat_Screen,
                                arguments: chatArguments);
                          });
                    },
                  )
            : CustomPlaceholder(message: strNoChats);
      },
    );
  }
}
