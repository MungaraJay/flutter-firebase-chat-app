import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;
  CustomIconButton({this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blueGrey, Colors.blueGrey[300]],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight),
              borderRadius: BorderRadius.circular(40)),
          padding: EdgeInsets.all(12),
          child: Icon(iconData, color: lightColor)),
    );
  }
}
