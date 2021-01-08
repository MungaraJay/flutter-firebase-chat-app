import 'package:fluttertoast/fluttertoast.dart';

RegExp emailExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

bool isValidEmail(String email) {
  if (emailExp.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}

void displayToast(String toastMsg){
  Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM
  );
}
