import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/register/register_event.dart';
import 'package:flutter_fire_chat/bloc/register/register_state.dart';
import 'package:flutter_fire_chat/services/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitState());
  AuthService authService = AuthService();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterInitAction) {
      yield* _mapRegisterInitStateToState(event);
    } else if (event is RegisterInProgressAction) {
      yield* _mapRegisterInProgressStateToState(event);
    } else if (event is RegisterChangesAction) {
      yield* _mapRegisterChangeStateToState(event);
    } else if (event is RegisterPressAction) {
      yield* _mapRegisterPressStateToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterInitStateToState(RegisterInitAction event) async* {
    yield RegisterInitState();
  }

  Stream<RegisterState> _mapRegisterInProgressStateToState(RegisterInProgressAction event) async* {
    yield RegisterInProgressState(event.isLoading);
  }

  Stream<RegisterState> _mapRegisterChangeStateToState(RegisterChangesAction event) async* {
    yield RegisterChangesState();
  }

  Stream<RegisterState> _mapRegisterPressStateToState(RegisterPressAction event) async* {
    yield RegisterInProgressState(true);

    try {
      await authService.signUpWithEmailAndPassword(event.email, event.password, event.username);

      yield RegisterSuccessState();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        yield RegisterFailureState("Account already registered with other different credential!!");
      } else if (e.code == 'credential-already-in-use') {
        yield RegisterFailureState("Credentials are already in use!!");
      } else if (e.code == 'email-already-in-use') {
        yield RegisterFailureState("Email already in use!!");
      } else if (e.code == 'network-request-failed') {
        yield RegisterFailureState("Please check your internet connection and try again!!");
      } else if (e.code == 'wrong-password') {
        yield RegisterFailureState("Please enter valid password!!");
      } else {
        yield RegisterFailureState("User registration failed. Please try again!!");
      }
    }catch (e) {
      yield RegisterFailureState("User registration failed. Please try again!!");
    }
  }
}
