import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/login/login_event.dart';
import 'package:flutter_fire_chat/bloc/login/login_state.dart';
import 'package:flutter_fire_chat/services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitState());
  AuthService authService = AuthService();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInitAction) {
      yield* _mapLoginInitStateToState(event);
    } else if (event is LoginInProgressAction) {
      yield* _mapLoginInProgressStateToState(event);
    } else if (event is LoginChangesAction) {
      yield* _mapLoginChangeStateToState(event);
    } else if (event is LoginPressAction) {
      yield* _mapLoginPressStateToState(event);
    }
  }

  Stream<LoginState> _mapLoginInitStateToState(LoginInitAction event) async* {
    yield LoginInitState();
  }

  Stream<LoginState> _mapLoginInProgressStateToState(LoginInProgressAction event) async* {
    yield LoginInProgressState(event.isLoading);
  }

  Stream<LoginState> _mapLoginChangeStateToState(LoginChangesAction event) async* {
    yield LoginChangesState();
  }

  Stream<LoginState> _mapLoginPressStateToState(LoginPressAction event) async* {
    yield LoginInProgressState(true);

    try {
      await authService.signInWithEmailAndPassword(event.email, event.password);

      yield LoginSuccessState();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        yield LoginFailureState("Account already registered with other different credential!!");
      } else if (e.code == 'credential-already-in-use') {
        yield LoginFailureState("Credentials are already in use!!");
      } else if (e.code == 'email-already-in-use') {
        yield LoginFailureState("Email already in use!!");
      } else if (e.code == 'network-request-failed') {
        yield LoginFailureState("Please check your internet connection and try again!!");
      } else if (e.code == 'wrong-password') {
        yield LoginFailureState("Please enter valid password!!");
      } else {
        yield LoginFailureState("User login failed. Please try again!!");
      }
    }catch (e) {
      yield LoginFailureState("User login failed. Please try again!!");
    }
  }
}
