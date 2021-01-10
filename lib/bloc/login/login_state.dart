import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginInProgressState extends LoginState {
  final bool isLoading;
  LoginInProgressState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class LoginFBInProgressState extends LoginState {
  final bool isFBLoading;
  LoginFBInProgressState(this.isFBLoading);

  @override
  List<Object> get props => [isFBLoading];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFBSuccessState extends LoginState {

  @override
  List<Object> get props => [];
}

class LoginFailureState extends LoginState {
  final String message;
  LoginFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class LoginFBFailureState extends LoginState {
  final String message;
  LoginFBFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class LoginChangesState extends LoginState {
  @override
  List<Object> get props => [];
}
