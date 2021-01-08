import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_images.dart';

class UserTile extends StatelessWidget {
  final Function onPressed;
  final String userName;
  final String userEmail;

  UserTile({this.userName, this.userEmail, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 30, backgroundImage: AssetImage(userImage)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              color: darkColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            userEmail,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
