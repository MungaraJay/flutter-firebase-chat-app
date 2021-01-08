import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchQueryToggleState extends SearchState {
  final bool isSearching;

  SearchQueryToggleState(this.isSearching);

  @override
  List<Object> get props => [isSearching];
}

class SearchQueryUpdateState extends SearchState {
  final String searchQuery;
  final QuerySnapshot searchResultSnapshot;
  SearchQueryUpdateState(this.searchQuery, this.searchResultSnapshot);

  @override
  List<Object> get props => [searchQuery, searchResultSnapshot];
}

class SearchQueryClearState extends SearchState {
  final QuerySnapshot searchResultSnapshot;
  final bool isSearching;

  SearchQueryClearState(this.isSearching, this.searchResultSnapshot);

  @override
  List<Object> get props => [isSearching, this.searchResultSnapshot];
}

class SearchChatRoomSuccessful extends SearchState {
  final String chatRoomId;
  SearchChatRoomSuccessful(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}

class SearchChatRoomFailure extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchChangesState extends SearchState {
  @override
  List<Object> get props => [];
}
