import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginInitAction extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginInProgressAction extends LoginEvent {
  final bool isLoading;
  LoginInProgressAction(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class LoginChangesAction extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginPressAction extends LoginEvent {
  final String email;
  final String password;
  LoginPressAction(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}