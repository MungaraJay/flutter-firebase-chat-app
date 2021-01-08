import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitAction extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeLogoutAction extends HomeEvent {

  @override
  List<Object> get props => [];
}

class HomeChangesAction extends HomeEvent {
  @override
  List<Object> get props => [];
}