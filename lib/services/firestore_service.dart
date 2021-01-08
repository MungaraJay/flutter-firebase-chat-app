import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';

class FirestoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future addUserInfo(userData) async {
    return await firebaseFirestore
        .collection(Users_List)
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserInfo(String email) async {
    return firebaseFirestore
        .collection(Users_List)
        .where(User_Email, isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future searchByName(String searchKey) async {
    // return firebaseFirestore
    //     .collection(Users_List)
    //     .where(User_Name, isEqualTo: searchKey)
    //     .get();

    return await firebaseFirestore
        .collection(Users_List)
        .where(User_Name, isGreaterThanOrEqualTo: searchKey)
        .where(User_Name, isLessThan: searchKey + 'z')
        .get();
  }

  Future addchatRoom(chatRoom, chatRoomId) async {
    return await firebaseFirestore
        .collection(User_ChatRooms)
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomsId) async {
    return firebaseFirestore
        .collection(User_ChatRooms)
        .doc(chatRoomsId)
        .collection(User_Chats)
        .orderBy(User_Time)
        .snapshots();
  }

  Future<void> addMessage(String chatRoomsId, chatMessageData) async {
    return await firebaseFirestore
        .collection(User_ChatRooms)
        .doc(chatRoomsId)
        .collection(User_Chats)
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String username) async {
    return await firebaseFirestore
        .collection(User_ChatRooms)
        .where(Users_List, arrayContains: username)
        .snapshots();
  }
}
