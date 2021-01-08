import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterInProgressState extends RegisterState {
  final bool isLoading;
  RegisterInProgressState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class RegisterSuccessState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterFailureState extends RegisterState {
  final String message;
  RegisterFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterChangesState extends RegisterState {
  @override
  List<Object> get props => [];
}
