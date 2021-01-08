import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

RegExp emailExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

bool isValidEmail(String email) {
  if (emailExp.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}

void displayToast(String toastMsg, BuildContext context) {
  Toast.show(
      toastMsg, context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
}
