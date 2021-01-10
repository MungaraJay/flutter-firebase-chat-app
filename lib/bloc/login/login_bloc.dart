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
    } else if (event is FBLoginPressAction) {
      yield* _mapFBLoginPressStateToState(event);
    }
  }

  Stream<LoginState> _mapLoginInitStateToState(LoginInitAction event) async* {
    yield LoginInitState();
  }

  Stream<LoginState> _mapLoginInProgressStateToState(
      LoginInProgressAction event) async* {
    yield LoginInProgressState(event.isLoading);
  }

  Stream<LoginState> _mapLoginChangeStateToState(
      LoginChangesAction event) async* {
    yield LoginChangesState();
  }

  Stream<LoginState> _mapLoginPressStateToState(LoginPressAction event) async* {
    yield LoginInProgressState(true);

    try {
      await authService.signInWithEmailAndPassword(event.email, event.password);

      yield LoginSuccessState();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        yield LoginFailureState(
            "Account already registered with other facebook provider!!");
      } else if (e.code == 'credential-already-in-use') {
        yield LoginFailureState("Credentials are already in use!!");
      } else if (e.code == 'email-already-in-use') {
        yield LoginFailureState("Email already in use!!");
      } else if (e.code == 'network-request-failed') {
        yield LoginFailureState(
            "Please check your internet connection and try again!!");
      } else if (e.code == 'wrong-password') {
        yield LoginFailureState("Please enter valid password!!");
      } else {
        yield LoginFailureState("User login failed. Please try again!!");
      }
    } catch (e) {
      yield LoginFailureState("User login failed. Please try again!!");
    }
  }

  Stream<LoginState> _mapFBLoginPressStateToState(
      FBLoginPressAction event) async* {
    yield LoginFBInProgressState(true);

    try {
      await authService.signInWithFacebook();

      yield LoginFBSuccessState();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        yield LoginFBFailureState(
            "Account already registered with other email provider!!");
      } else if (e.code == 'credential-already-in-use') {
        yield LoginFBFailureState("Credentials are already in use!!");
      } else if (e.code == 'email-already-in-use') {
        yield LoginFBFailureState("Email already in use!!");
      } else if (e.code == 'network-request-failed') {
        yield LoginFBFailureState(
            "Please check your internet connection and try again!!");
      } else if (e.code == 'wrong-password') {
        yield LoginFBFailureState("Please enter valid password!!");
      } else {
        yield LoginFBFailureState("User login failed. Please try again!!");
      }
    } catch (e) {
      yield LoginFBFailureState("User login failed. Please try again!!");
    }
  }
}
