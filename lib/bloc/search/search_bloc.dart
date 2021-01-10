import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/search/search_event.dart';
import 'package:flutter_fire_chat/bloc/search/search_state.dart';
import 'package:flutter_fire_chat/services/firestore_service.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitState());
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot searchResultSnapshot;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchInitAction) {
      yield* _mapSearchInitStateToState(event);
    } else if (event is SearchIsSearchingQueryAction) {
      yield* _mapSearchIsSearchingQueryStateToState(event);
    } else if (event is SearchUpdateQueryAction) {
      yield* _mapSearchUpdateQueryStateToState(event);
    } else if (event is SearchClearQueryAction) {
      yield* _mapSearchClearQueryStateToState(event);
    } else if (event is SearchChangesAction) {
      yield* _mapSearchChangeStateToState(event);
    } else if (event is SearchCreateChatAction) {
      yield* _mapSearchCreateChatStateToState(event);
    }
  }

  Stream<SearchState> _mapSearchIsSearchingQueryStateToState(
      SearchIsSearchingQueryAction event) async* {
    try {
      yield SearchQueryToggleState(event.isSearching);
    } catch (e) {
      yield SearchQueryToggleState(false);
    }
  }

  Stream<SearchState> _mapSearchUpdateQueryStateToState(
      SearchUpdateQueryAction event) async* {
    try {
      yield SearchChangesState();

      final searchResultSnapshot =
          await FirestoreService().searchByName(event.searchQuery);

      yield SearchQueryUpdateState(event.searchQuery, searchResultSnapshot);
    } catch (e) {
      yield SearchQueryUpdateState("", searchResultSnapshot);
    }
  }

  Stream<SearchState> _mapSearchCreateChatStateToState(
      SearchCreateChatAction event) async* {
    try {
      List<String> users = [auth.currentUser.uid, event.receiverUserId];
      String chatRoomId =
          getChatRoomId(auth.currentUser.uid, event.receiverUserId);
      final currentUserName = await auth.currentUser.displayName;

      List userDetails = [];
      userDetails.add({
        User_ID: auth.currentUser.uid,
        User_Email: auth.currentUser.email,
        User_Name: currentUserName
      });

      userDetails.add({
        User_ID: event.receiverUserId,
        User_Email: event.receiverUserEmail,
        User_Name: event.receiverUserName
      });

      Map<String, dynamic> chatRoom = {
        Users_List: users,
        User_ChatRoomId: chatRoomId,
        User_Details: FieldValue.arrayUnion(userDetails),
      };
      await firestoreService.addchatRoom(chatRoom, chatRoomId);
      print("data : ");

      yield SearchChatRoomSuccessful(chatRoomId);
    } catch (e) {
      print("data : ${e.toString()}");
      yield SearchChatRoomFailure();
    }
  }

  Stream<SearchState> _mapSearchClearQueryStateToState(
      SearchClearQueryAction event) async* {
    try {
      yield SearchQueryClearState(event.isSearching, searchResultSnapshot);
    } catch (e) {
      yield SearchQueryClearState(false, searchResultSnapshot);
    }
  }

  Stream<SearchState> _mapSearchInitStateToState(
      SearchInitAction event) async* {
    yield SearchInitState();
  }

  Stream<SearchState> _mapSearchChangeStateToState(
      SearchChangesAction event) async* {
    yield SearchChangesState();
  }

  getChatRoomId(String a, String b) {
    a.replaceAll(' ', '');
    b.replaceAll(' ', '');
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
