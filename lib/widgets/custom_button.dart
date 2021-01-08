import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  CustomButton({this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ButtonGradientStartColor, ButtonGradientEndColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ThemeColor.withOpacity(0.5),
              offset: Offset(0, 10),
              blurRadius: 15,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Center(
            child: Text(
              buttonText,
              style: ButtonTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
