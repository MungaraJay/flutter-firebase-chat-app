import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColor)));
  }
}
