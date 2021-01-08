import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';

class CustomChatInput extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  CustomChatInput({this.textController, this.hintText});

  @override
  _CustomChatInputState createState() => _CustomChatInputState();
}

class _CustomChatInputState extends State<CustomChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: widget.textController,
        style:
        TextStyle(color: lightColor, fontSize: 18),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, bottom: 6),
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: Colors.grey[200], fontSize: 16),
            border: InputBorder.none),
      ),
    );
  }
}
