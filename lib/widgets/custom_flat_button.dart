import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';

class CustomFlatButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  CustomFlatButton({this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: FlatButtonTextStyle(),
        ),
      ),
    );
  }
}
