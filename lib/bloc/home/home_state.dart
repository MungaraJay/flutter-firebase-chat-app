import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSuccessState extends HomeState {
  final Stream<QuerySnapshot> chatRooms;
  HomeSuccessState(this.chatRooms);

  @override
  List<Object> get props => [chatRooms];
}

class HomeFailureState extends HomeState {

  @override
  List<Object> get props => [];
}

class HomeLogoutState extends HomeState {

  @override
  List<Object> get props => [];
}

class HomeChangesState extends HomeState {
  @override
  List<Object> get props => [];
}
