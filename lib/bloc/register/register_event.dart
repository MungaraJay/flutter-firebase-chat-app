import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterInitAction extends RegisterEvent {
  @override
  List<Object> get props => [];
}

class RegisterInProgressAction extends RegisterEvent {
  final bool isLoading;
  RegisterInProgressAction(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class RegisterChangesAction extends RegisterEvent {
  @override
  List<Object> get props => [];
}

class RegisterPressAction extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  RegisterPressAction(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}