import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController textController;
  final TextInputType textInputType;
  final IconData prefixIcon;
  final String labelText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final validator;

  CustomInput(
      {this.textController,
        this.labelText,
        this.textInputType,
        this.prefixIcon,
        this.obscureText = false,
        this.textInputAction = TextInputAction.next,
        this.validator});
  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.obscureText,
        controller: widget.textController,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        cursorColor: ThemeColor,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon, color: ThemeColor),
          labelText: widget.labelText,
          labelStyle: TextInputStyle(textInputHintColor),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: textInputColor)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor),
          ),
        ),
      ),
    );
  }
}
