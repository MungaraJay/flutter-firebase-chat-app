import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/search/search_bloc.dart';
import 'package:flutter_fire_chat/bloc/search/search_event.dart';
import 'package:flutter_fire_chat/bloc/search/search_state.dart';
import 'package:flutter_fire_chat/containers/chat/chat_arguments.dart';
import 'package:flutter_fire_chat/containers/chat/user_tile.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';
import 'package:flutter_fire_chat/utils/util_routes.dart';
import 'package:flutter_fire_chat/utils/util_strings.dart';
import 'package:flutter_fire_chat/widgets/custom_placeholder.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchUsersController = TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool _isSearching = false;
  String searchUser = strSearchUser;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        try {
          if (state is SearchQueryToggleState) {
            _isSearching = state.isSearching;

            BlocProvider.of<SearchBloc>(context).add(SearchChangesAction());
          } else if (state is SearchQueryUpdateState) {
            searchResultSnapshot = state.searchResultSnapshot;
            if (state.searchQuery.trim().length == 0) {
              _searchUsersController.clear();
            }

            BlocProvider.of<SearchBloc>(context).add(SearchChangesAction());
          } else if (state is SearchQueryClearState) {
            _isSearching = state.isSearching;
            searchResultSnapshot = state.searchResultSnapshot;
            _searchUsersController.clear();

            BlocProvider.of<SearchBloc>(context).add(SearchChangesAction());
          } else if (state is SearchChatRoomSuccessful){
            ChatArguments chatArguments = ChatArguments(chatRoomId: state.chatRoomId);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, Route_Chat_Screen, arguments: chatArguments);
            });

            BlocProvider.of<SearchBloc>(context).add(SearchChangesAction());
          } else if (state is SearchChatRoomFailure){
            BlocProvider.of<SearchBloc>(context).add(SearchChangesAction());
          }
        } catch (e) {
          print(e);
        }

        return Scaffold(
          appBar: AppBar(
            leading: _isSearching
                ? const BackButton()
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_outlined)),
            title: _isSearching ? _buildSearchField() : Text(strUsers),
            actions: _buildActions(),
          ),
          body: getBody(),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchUsersController.dispose();
    super.dispose();
  }

  Widget getBody() {
    return searchResultSnapshot != null
        ? searchResultSnapshot.docs.length == 0
            ? CustomPlaceholder(message: strNoUsers)
            : ListView.builder(
                padding: EdgeInsets.only(top: 8),
                shrinkWrap: true,
                itemCount: searchResultSnapshot.docs.length,
                itemBuilder: (context, index) {
                  final userDisplayName = searchResultSnapshot.docs[index]
                      .data()[User_DisplayName];
                  final email =
                      searchResultSnapshot.docs[index].data()[User_Email];
                  final userId =
                      searchResultSnapshot.docs[index].data()[User_ID];
                  final userName =
                      searchResultSnapshot.docs[index].data()[User_Name];

                  return UserTile(
                      userEmail: email,
                      userName: userDisplayName,
                      onPressed: () {
                        sendMessage(userId, email, userDisplayName);
                      });
                },
              )
        : CustomPlaceholder(message: strFindUsers);
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchUsersController,
      autofocus: true,
      cursorColor: lightColor,
      decoration: InputDecoration(
        hintText: strSearchUser,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchUsersController == null ||
                _searchUsersController.text.isEmpty) {
              Navigator.pop(context);
              return;
            } else {
              _clearSearchQuery();
            }
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  sendMessage(String receiverUserId, String receiverUserEmail, String receiverUserName) async {
    BlocProvider.of<SearchBloc>(context).add(SearchCreateChatAction(receiverUserId, receiverUserEmail, receiverUserName));
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    BlocProvider.of<SearchBloc>(context)
        .add(SearchIsSearchingQueryAction(true));
  }

  void updateSearchQuery(String newQuery) {
    if (_searchUsersController.text.trim().isNotEmpty) {
      BlocProvider.of<SearchBloc>(context)
          .add(SearchUpdateQueryAction(newQuery));
    }
  }

  void _stopSearching() {
    BlocProvider.of<SearchBloc>(context).add(SearchClearQueryAction(false, ""));
  }

  void _clearSearchQuery() {
    BlocProvider.of<SearchBloc>(context).add(SearchUpdateQueryAction(""));
  }
}
