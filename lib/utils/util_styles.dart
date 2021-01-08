import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';

TextStyle TextInputStyle(Color textColor) {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
}

TextStyle HeaderStyle({Color textColor}) {
  if (textColor == null) {
    textColor = HeaderTextColor;
  }
  return TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w900,
    color: textColor,
  );
}

TextStyle SubTitleStyle({Color textColor}) {
  if (textColor == null) {
    textColor = SubTitleTextColor;
  }
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
}

TextStyle DescriptionStyle({Color textColor}) {
  if (textColor == null) {
    textColor = DescriptionTextColor;
  }
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
}

TextStyle ButtonTextStyle({Color textColor, double fontSize}) {
  if (textColor == null) {
    textColor = ButtonTextColor;
  }
  if (fontSize == null) {
    fontSize = 20.0;
  }
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
}

TextStyle FlatButtonTextStyle({Color textColor, double fontSize}) {
  if (textColor == null) {
    textColor = ThemeColor;
  }
  if (fontSize == null) {
    fontSize = 20.0;
  }
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
}

TextStyle ErrorTextStyle() {
  return TextStyle(
    color: ErrorColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}

BoxDecoration TextBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(
      color: textInputColor,
    ),
  );
}