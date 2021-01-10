import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_fire_chat/helpers/prefs.dart';
import 'package:flutter_fire_chat/services/firestore_service.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fbLogin = FacebookLogin();
  final firestoreService = FirestoreService();

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Email user : ${credential.user}");

      final response = await firestoreService.getUserInfo(email);
      if (response.docs != null &&
          response.docs.length > 0 &&
          response.docs.first != null) {
        final item = response.docs.first.data();
        storeUserDataInPrefs(item[User_ID], item[User_Email], item[User_DisplayName]);
      } else {
        storeUserDataInPrefs(credential.user.uid, credential.user.email, credential.user.displayName);
      }

      return credential.user;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Map<String, String> userDetails = {
        User_Name: name.toLowerCase().trim(),
        User_Email: credential.user.email,
        User_ID: credential.user.uid,
        User_DisplayName: name
      };

      if (credential.additionalUserInfo.isNewUser) {
        await firestoreService.addUserInfo(userDetails);
        await auth.currentUser.updateProfile(displayName: name);
      }
      storeUserDataInPrefs(credential.user.uid, credential.user.email, name);

      print("Email user : ${credential.user}");
      return credential.user;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future signInWithFacebook() async {
    try {
      FacebookLoginResult facebookLoginResult =
          await fbLogin.logIn(['email', 'public_profile']);
      print("facebookLoginResult : ${facebookLoginResult}");
      print("facebookLoginResult : ${facebookLoginResult.status}");
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(facebookAccessToken.token);
        UserCredential credential =
            await auth.signInWithCredential(authCredential);

        Map<String, String> userDetails = {
          User_Name: credential.user.displayName.toLowerCase().trim(),
          User_Email: credential.user.email,
          User_ID: credential.user.uid,
          User_DisplayName: credential.user.displayName
        };
        if (credential.additionalUserInfo.isNewUser) {
          await firestoreService.addUserInfo(userDetails);
        }
        storeUserDataInPrefs(credential.user.uid, credential.user.email,
            credential.user.displayName);

        print("Facebook user : ${credential.user}");
        return credential.user;
      } else if (facebookLoginResult.status ==
          FacebookLoginStatus.cancelledByUser) {
        throw Exception('Facebook login cancelled by user!');
      } else if (facebookLoginResult.status == FacebookLoginStatus.error) {
        throw Exception(facebookLoginResult.errorMessage);
      } else {
        throw Exception('Facebook login failed!');
      }
    } catch (facebookError) {
      print("FacebookError : ${facebookError}");

      throw facebookError;
    }
  }

  Future resetPass(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future signOut() async {
    try {
      print("${auth.currentUser.providerData}");
      for (UserInfo info in auth.currentUser.providerData) {
        if (info.providerId == 'facebook.com') {
          await fbLogin.logOut();
          return await auth.signOut();
        } else if (info.providerId == 'password') {
          return await auth.signOut();
        }
      }
      return;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  storeUserDataInPrefs(uid, email, displayName) {
    Prefs.setUserId(uid);
    Prefs.setUserEmail(email);
    Prefs.setUserDisplayName(displayName);
  }
}
