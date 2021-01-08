import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/home/home_event.dart';
import 'package:flutter_fire_chat/bloc/home/home_state.dart';
import 'package:flutter_fire_chat/services/auth_service.dart';
import 'package:flutter_fire_chat/services/firestore_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitState());
  final AuthService authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeInitAction) {
      yield* _mapHomeInitStateToState(event);
    } else if (event is HomeLogoutAction) {
      yield* _mapHomeLogoutStateToState(event);
    } else if (event is HomeChangesAction) {
      yield* _mapHomeChangeStateToState(event);
    }
  }

  Stream<HomeState> _mapHomeInitStateToState(HomeInitAction event) async* {
    try {
      Stream<QuerySnapshot> chatRooms = await firestoreService.getUserChats(auth.currentUser.uid);

      yield HomeSuccessState(chatRooms);
    } catch (e) {
      print("getUserChats() Exception : ${e.toString()}");

      yield HomeFailureState();
    }
  }

  Stream<HomeState> _mapHomeLogoutStateToState(HomeLogoutAction event) async* {
    try {
      await authService.signOut();

      yield HomeLogoutState();
    } catch (e) {
      print("signOut() Exception : ${e.toString()}");

      yield HomeLogoutState();
    }
  }

  Stream<HomeState> _mapHomeChangeStateToState(HomeChangesAction event) async* {
    yield HomeChangesState();
  }
}
