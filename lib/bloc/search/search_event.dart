import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchInitAction extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SearchIsSearchingQueryAction extends SearchEvent {
  final bool isSearching;
  SearchIsSearchingQueryAction(this.isSearching);

  @override
  List<Object> get props => [isSearching];
}

class SearchUpdateQueryAction extends SearchEvent {
  final String searchQuery;
  SearchUpdateQueryAction(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}

class SearchClearQueryAction extends SearchEvent {
  final String searchQuery;
  final bool isSearching;

  SearchClearQueryAction(this.isSearching, this.searchQuery);

  @override
  List<Object> get props => [isSearching, searchQuery];
}

class SearchCreateChatAction extends SearchEvent {
  final String receiverUserId;
  final String receiverUserEmail;
  final String receiverUserName;

  SearchCreateChatAction(this.receiverUserId, this.receiverUserEmail, this.receiverUserName);

  @override
  List<Object> get props => [receiverUserId, receiverUserEmail, receiverUserName];
}

class SearchChangesAction extends SearchEvent {
  @override
  List<Object> get props => [];
}