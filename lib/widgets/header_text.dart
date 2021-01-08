import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';

class HeaderText extends StatelessWidget {
  final String headerText;
  HeaderText({this.headerText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          headerText,
          style: HeaderStyle(),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          width: 60,
          child: Divider(thickness: 5, color: ThemeColor),
        )
      ],
    );
  }
}
