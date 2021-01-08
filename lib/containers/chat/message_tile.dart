import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;

  MessageTile({@required this.message, @required this.sendByMe, @required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 12, right: sendByMe ? 12 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
        sendByMe ? EdgeInsets.only(left: 32) : EdgeInsets.only(right: 32),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16))
                : BorderRadius.only(
                bottomLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [Colors.red[300], Colors.red]
                  : [Colors.blueGrey, Colors.blueGrey[300]],
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding:
              EdgeInsets.only(top: 12, bottom: 10, left: 16, right: 16),
              child: Text(message,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(DateFormat(dateFormat_DDMMMHHMM).format(DateTime.fromMicrosecondsSinceEpoch(time * 1000)),
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}