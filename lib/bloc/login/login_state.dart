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

class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailureState extends LoginState {
  final String message;
  LoginFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class LoginChangesState extends LoginState {
  @override
  List<Object> get props => [];
}
