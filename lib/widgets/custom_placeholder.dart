import 'package:flutter/material.dart';

class CustomPlaceholder extends StatelessWidget {
  final String message;
  CustomPlaceholder({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(message,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)));
  }
}
